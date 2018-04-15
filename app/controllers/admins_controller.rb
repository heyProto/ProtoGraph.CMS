class AdminsController < ApplicationController
  
  before_action :authenticate_user!
  
  def access_security
    @is_admin = true
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
  end
  
  def account_owners
    @is_admin = true
    @permissions = @account.permissions.not_hidden.where(ref_role_slug: "owner").includes(:user).page params[:page]
    @permission_invite = PermissionInvite.new
    @permission_invites = @account.permission_invites.where(ref_role_slug: "owner")
    @people_count = @account.permissions.not_hidden.where(ref_role_slug: "owner").count
    @pending_invites_count = @account.permission_invites.where(ref_role_slug: "owner").count
    @permission_invites = @account.permission_invites.where(ref_role_slug: "owner")
    @people_count = @account.permissions.not_hidden.where(ref_role_slug: "owner").count
    @pending_invites_count = @account.permission_invites.where(ref_role_slug: "owner").count
  end
  
end
