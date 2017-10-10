class ViewCastsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_view_cast, only: [:show, :edit, :destroy, :recreate, :update]

    def new
        @new_image = Image.new
    end

    def index
        @view_casts_count = @folder.view_casts.count
        @streams_count = @folder.streams.count
        @articles_count = @folder.articles.count
        @view_casts = @folder.view_casts.order(updated_at: :desc).page(params[:page]).per(30)
        @is_viewcasts_present = @view_casts.count != 0
    end

    def show
        @folders = @account.folders
        if (Time.now - @view_cast.updated_at) > 5.minute and (@view_cast.is_invalidating)
            @view_cast.update_column(:is_invalidating, false)
        end
        @view_cast_seo_blockquote = @view_cast.seo_blockquote.to_s.split('`').join('\`')
        @view_casts_count = @folder.view_casts.count
        @streams_count = @folder.streams.count
        @articles_count = @folder.articles.count
        @page_views = @view_cast.piwik_metrics.where(piwik_module: 'Events', piwik_metric_name: 'page_view').first
        render layout: "application-fluid"
    end

    def edit
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
                redirect_to account_folder_view_cast_path(@account, @view_cast.folder, @view_cast), notice: t('us')
            end
        else
            render :show
        end

    end

    def destroy
        @view_cast.updator = current_user
        @view_cast.folder = @account.folders.find_by(name: "Recycle Bin")
        if @view_cast.save
            redirect_to account_folder_view_casts_path(@account, @folder), notice: "Card was deleted successfully"
        else
            redirect_to account_folder_view_cast_path(@account, @folder, @view_cast), alert: "Card could not be deleted"
        end
    end

    def set_view_cast
        @view_cast = @account.view_casts.friendly.find(params[:id])
    end

    private

    def view_cast_params
        params.require(:view_cast).permit(:folder_id, :default_view, :redirect_url)
    end

end
