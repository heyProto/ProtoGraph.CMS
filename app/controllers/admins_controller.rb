class AdminsController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
  end

  def site_setup
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)  
  end
  
  def access_security
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
  end

  def product_theme
    if @site.logo_image_id.nil?
      @site.build_logo_image
    end
    if @site.favicon_id.nil?
      @site.build_favicon
    end
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
  end

  def product_integrations
    @permission_roles = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
  end

  def editorial_folders
  end
  
end
