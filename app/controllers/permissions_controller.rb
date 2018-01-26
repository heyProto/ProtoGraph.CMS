class PermissionsController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_add_site_people
  before_action :set_permission, only: [:change_owner_role, :change_role, :destroy]

  def change_owner_role
    @permissions = @account.permissions.not_hidden.where(ref_role_slug: "owner").includes(:user).page params[:page]
    @permission_invite = PermissionInvite.new
    @permission_invites = @account.permission_invites.where(ref_role_slug: "owner")
    @people_count = @account.permissions.not_hidden.where(ref_role_slug: "owner").count
    @pending_invites_count = @account.permission_invites.where(ref_role_slug: "owner").count
    @permission_invites = @account.permission_invites.where(ref_role_slug: "owner")
    @people_count = @account.permissions.not_hidden.where(ref_role_slug: "owner").count
    @pending_invites_count = @account.permission_invites.where(ref_role_slug: "owner").count
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
    @sites = [[@site.name, @site.id]] #@account.sites.pluck(:name, :id)
  end

  def change_role
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
      params.require(:permission).permit(:user_id, :account_id, :ref_role_slug, :status, :created_by, :updated_by, :redirect_url, :site_ref_role_slug, sites: [])
    end
end
