class AdminsController < ApplicationController
  
  before_action :authenticate_user!
    
  def site_owners
    @is_admin = true
    @permissions = @site.permissions.not_hidden.where(ref_role_slug: "owner").includes(:user).page params[:page]
    @permission_invite = PermissionInvite.new
    @permission_invites = @site.permission_invites.where(ref_role_slug: "owner")
    @people_count = @site.permissions.not_hidden.where(ref_role_slug: "owner").count
    @pending_invites_count = @site.permission_invites.where(ref_role_slug: "owner").count
    @permission_invites = @site.permission_invites.where(ref_role_slug: "owner")
    @people_count = @site.permissions.not_hidden.where(ref_role_slug: "owner").count
    @pending_invites_count = @site.permission_invites.where(ref_role_slug: "owner").count
  end
  
end
