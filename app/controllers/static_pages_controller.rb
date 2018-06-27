class StaticPagesController < ApplicationController

  def index
    if current_user
      n_sites = current_user.sites.count
      if n_sites  == 0
        redirect_to new_site_path
      else n_sites > 1
        site = current_user.sites.first
        permission = current_user.owner_role(site.id) || current_user.permission_object(site.id)
        folder = permission.permission_role.can_see_all_folders ? site.folders.active.where(is_trash: false).first : current_user.folders(site).active.where(is_trash: false).first
        redirect_to site_folder_view_casts_path(site, folder)
      end
    else
      redirect_to new_user_session_path
  	end
  end

end