class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
        @accounts = current_user.accounts
        @account = Account.new
    end

    def edit
      @user = current_user
      @accounts_owned = Account.where(id: current_user.permissions.where(ref_role_slug: "owner", permissible_type: "Account").pluck(:permissible_id).uniq)
      @accounts_member = Account.where(id: Site.where(id: current_user.permissions.where(permissible_type: "Site").where.not(ref_role_slug: "owner").pluck(:permissible_id).uniq).pluck(:account_id).uniq)
      @account = Account.new
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
          redirect_to edit_user_path, notice: t('cs')
      else
          @accounts_owned = Account.where(id: current_user.permissions.where(ref_role_slug: "owner").pluck(:account_id).uniq)
          @accounts_member = Account.where(id: current_user.permissions.where.not(ref_role_slug: "owner").pluck(:account_id).uniq)
          @account = Account.new
          render :edit, alert: @user.errors.full_messages
      end

    end

    private

      def user_params
        params.require(:user).permit(:name, :email)
      end

end