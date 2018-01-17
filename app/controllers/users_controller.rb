class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
        @accounts = current_user.accounts
        @account = Account.new
    end
    
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
          redirect_to edit_user_registration_path, notice: t('cs')
      else
          render edit_user_registration_path, alert: @user.errors.full_messages
      end
      
    end
    
    private

      def user_params
        params.require(:user).permit(:name, :email)
      end
    
end