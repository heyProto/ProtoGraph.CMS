class PermissionsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_permission, only: [:show, :edit, :update, :destroy]

  def index
    @permissions = @account.permissions.includes(:user)
    @permission_invite = PermissionInvite.new
    @permission_invites = @account.permission_invites

    @people_count = @account.users.count
    @pending_invites_count = @account.permission_invites.count
    @permission_invites = @account.permission_invites
  end

  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy
    redirect_to account_path(@account), notice: t("ds")
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def permission_params
      params.require(:permission).permit(:user_id, :account_id, :created_by, :updated_by)
    end
end
