class ViewCastsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_view_cast, only: [:show, :edit, :destroy, :recreate, :update]
    before_action :sudo_can_see_all_view_casts, only: [:show, :edit, :update]

    def new
        @new_image = Image.new
    end

    def index
        @view_casts_count = @folder.view_casts.where.not(template_card_id: TemplateCard.to_story_cards_ids).count
        @streams_count = @folder.streams.count
        @view_casts = @permission_role.can_see_all_view_casts ? @folder.view_casts.where.not(template_card_id: TemplateCard.to_story_cards_ids).where(is_autogenerated: false).order(updated_at: :desc).page(params[:page]).per(30) : current_user.view_casts(@folder).where(is_autogenerated: false).order(updated_at: :desc).page(params[:page]).per(30)
        @is_viewcasts_present = @view_casts.count != 0
    end

    def show
        @folders_dropdown = @account.folders
        if (Time.now - @view_cast.updated_at) > 5.minute and (@view_cast.is_invalidating)
            @view_cast.update_column(:is_invalidating, false)
        end
        @view_cast_seo_blockquote = @view_cast.seo_blockquote.to_s.split('`').join('\`')
        @view_casts_count = @folder.view_casts.count
        @streams_count = @folder.streams.count
        @view_cast.collaborator_lists = @view_cast.users.pluck(:id)
    end

    def edit
        if @view_cast.is_disabled_for_edit
            redirect_to [@account, @site, @folder, @view_cast], alert: "Permission Denied."
        end
        @new_image = Image.new
    end

    def update
        v_c_params = view_cast_params
        v_c_params["stop_callback"] = true
        if @view_cast.update(v_c_params)
            track_activity(@view_cast)
            if @view_cast.redirect_url.present?
                redirect_to @view_cast.redirect_url, notice: t('us')
            else
                redirect_to account_site_folder_view_cast_path(@account, @site, @view_cast.folder, @view_cast), notice: t('us')
            end
        else
            render :show
        end

    end

    def destroy
        @view_cast.updator = current_user
        @view_cast.folder = @account.folders.find_by(name: "Recycle Bin")
        if @view_cast.save
            redirect_to account_site_folder_view_casts_path(@account, @site, @folder), notice: "Card was deleted successfully"
        else
            redirect_to account_site_folder_view_cast_path(@account, @site, @folder, @view_cast), alert: "Card could not be deleted"
        end
    end

    def set_view_cast
        @view_cast = @account.view_casts.friendly.find(params[:id])
    end

    private

    def view_cast_params
        params.require(:view_cast).permit(:folder_id, :default_view, :redirect_url, collaborator_lists: [])
    end

end
