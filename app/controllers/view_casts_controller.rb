class ViewCastsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_view_cast, only: [:show, :edit, :recreate]

    def new
    end

    def index
        redirect_to account_path(@account)
    end

    def show
    end

    def edit
    end

    def recreate
        mode = params[:mode]
        if ViewCast::Platforms.include?(mode)
            Thread.new do
                status = JSON.parse(@view_cast.status)
                status[mode] = 'creating'
                @view_cast.update_column(:status, status.to_json )
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

end