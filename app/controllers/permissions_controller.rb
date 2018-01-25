class PermissionsController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_add_site_people
  before_action :set_permission, only: [:change_role, :destroy]

  def change_role
    @permission = Permission.find(params[:id])
    @permission.update_attributes(permission_params)
    redirect_to permission_params[:redirect_url] , notice: "Successfully updated."
  end

  def destroy
    @permission.update_attributes(status: "Deactivated")
    redirect_to params[:redirect_url], notice: t("ds")
  end

  private

    def set_permission
      @permission = Permission.find(params[:id])
    end

    def permission_params
      params.require(:permission).permit(:user_id, :account_id, :ref_role_slug, :status, :created_by, :updated_by, :redirect_url)
    end
end
