class PermissionInvitesController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_account_settings
  before_action :set_permission_invite, only: [:show, :edit, :update, :destroy]

  def create
    @permission_invite = PermissionInvite.new(permission_invite_params)
    user = User.where(email: @permission_invite.email).first
    if user.present?
      @account.create_permission(user.id)
      redirect_to account_permissions_url(@account), notice: t("permission_invite.add")
    else
      if @permission_invite.save
        PermissionInvites.invite(current_user, @account, @permission_invite.email).deliver
        redirect_to account_permissions_url(@account), notice: t("permission_invite.invite")
      else
        @permissions = @account.permissions.includes(:user)
        @permission_invites = @account.permission_invites
        @people_count = @account.users.count
        @pending_invites_count = @account.permission_invites.count
        @permission_invites = @account.permission_invites
        render "permissions/index"
      end
    end
  end

  def destroy
    @permission_invite.destroy
    redirect_to account_permissions_url(@account), notice: t("permission_invite.removed")
  end

  private

    def set_permission_invite
      @permission_invite = PermissionInvite.find(params[:id])
    end

    def permission_invite_params
      params.require(:permission_invite).permit(:account_id, :email, :ref_role_slug, :created_by, :updated_by)
    end
end
