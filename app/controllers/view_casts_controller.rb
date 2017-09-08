class ViewCastsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_view_cast, only: [:show, :edit, :recreate]

    def new
    end

    def show
        @folders = @account.folders
        if (Time.now - @view_cast.updated_at) > 5.minute and (@view_cast.is_invalidating)
            @view_cast.update_column(:is_invalidating, false)
        end
        @view_cast_seo_blockquote = @view_cast.seo_blockquote.to_s.split('`').join('\`')
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

    def recreate
        mode = params[:mode]
        if ViewCast::Platforms.include?(mode)
            Thread.new do
                status = JSON.parse(@view_cast.status)
                status[mode] = 'creating'
                @view_cast.update_columns(status: status.to_json,updated_at: Time.now)
                @view_cast.save_png(mode)
                ActiveRecord::Base.connection.close
            end
            redirect_to account_view_cast_path(@account, @view_cast), notice: t('platform_create', platform: mode)
        else
            redirect_to account_view_cast_path(@account, @view_cast), alert: t('platform_not_in_the_list', platform: mode)
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