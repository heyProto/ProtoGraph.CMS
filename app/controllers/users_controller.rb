class UsersController < ApplicationController
    before_action :authenticate_user!

    def edit
      @user = current_user
      @new_site = Site.new
    end

    def update
      @user = User.find(params[:id])
      @new_site = Site.new
      if @user.update(user_params)
          redirect_to edit_user_path, notice: t('cs')
      else
        @sites_owned = Site.where(id: current_user.permissions.where(ref_role_slug: "owner", permissible_type: "Site").pluck(:permissible_id).uniq)
        @sites_member = Site.where(id: current_user.permissions.where(permissible_type: "Site").where.not(ref_role_slug: "owner"))
        render :edit, alert: @user.errors.full_messages
      end

    end

    private

      def user_params
        params.require(:user).permit(:name, :email, :bio, :website, :facebook, :twitter, :phone, :linkedin)
      end

end