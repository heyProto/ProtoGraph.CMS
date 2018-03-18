class AdminsController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    @is_admin = true
  end
  
  def sites
    @is_admin = true
  end
  
  def basic_theming
    @is_admin = true
    if @site.favicon_id.nil?
      @site.build_favicon
    end
  end

  def site_setup
    @is_admin = true
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)  
  end
  
  def access_security
    @is_admin = true
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
  end

  def site_theming
    @is_admin = true
    if @site.logo_image_id.nil?
      @site.build_logo_image
    end
  end

  def site_integrations
    @is_admin = true
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
  end

  def editorial_folders
    @is_admin = true
    @folders = @permission_role.can_see_all_folders ? @site.folders : current_user.folders(@site)
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
