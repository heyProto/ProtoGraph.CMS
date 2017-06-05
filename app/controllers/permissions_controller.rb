class PermissionsController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_account_settings
  before_action :set_permission, only: [:change_role, :destroy]

  def index
    @permissions = @account.permissions.includes(:user).page params[:page]
    @permission_invite = PermissionInvite.new
    @permission_invites = @account.permission_invites
    @people_count = @account.users.count
    @pending_invites_count = @account.permission_invites.count
    @permission_invites = @account.permission_invites
  end

  def change_role
    @permission = Permission.find(params[:id])
    @permission.update_attributes(ref_role_slug: params[:r])
    redirect_to account_permissions_path(@account), notice: "Successfully updated."
  end

  def destroy

    @permission.destroy
    redirect_to account_permissions_path(@account), notice: t("ds")
  end

  private

    def set_permission
      @permission = Permission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permission_params
      params.require(:permission).permit(:user_id, :account_id, :ref_role_slug, :status, :created_by, :updated_by)
    end
end
