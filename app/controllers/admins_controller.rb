class AdminsController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    @is_admin = true
  end

  def site_setup
    @is_admin = true
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)  
  end
  
  def access_security
    @is_admin = true
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
  end

  def product_theme
    @is_admin = true
    if @site.logo_image_id.nil?
      @site.build_logo_image
    end
    if @site.favicon_id.nil?
      @site.build_favicon
    end
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
  end

  def product_integrations
    @is_admin = true
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
  end

  def editorial_folders
    @is_admin = true
  end
  
end
