class ViewCastsController < ApplicationController

    def index
        @view_casts = @account.view_casts
    end

    def show
        @view_cast = @account.view_casts.find(params[:id])
    end

end