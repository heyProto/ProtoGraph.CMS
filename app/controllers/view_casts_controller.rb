class ViewCastsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_view_cast, only: [:show, :edit, :recreate]

    def new
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
        render layout: "application-fluid"
    end

    def edit
    end

    def update
        @view_cast = ViewCast.friendly.find(params[:id])
        if @view_cast.update(view_cast_params)
            track_activity(@view_cast)
            redirect_to account_folder_view_cast_path(@account, @view_cast.folder, @view_cast), notice: t('us')
        else
            render :show
        end

    end

    def set_view_cast
        @view_cast = @account.view_casts.friendly.find(params[:id])
    end

    private

    def view_cast_params
        params.require(:view_cast).permit(:folder_id)
    end

end