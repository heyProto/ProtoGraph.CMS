class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
        @accounts = current_user.accounts
        @account = Account.new
    end
end