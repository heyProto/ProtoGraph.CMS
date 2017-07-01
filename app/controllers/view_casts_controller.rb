class ViewCastsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_view_cast, only: [:show, :edit]

    def new
    end

    def index
        redirect_to account_path(@account)
    end

    def show
    end

    def edit
    end

    def set_view_cast
        @view_cast = @account.view_casts.friendly.find(params[:id])
    end

end