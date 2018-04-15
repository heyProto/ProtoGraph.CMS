class StaticPagesController < ApplicationController

  def index
    if current_user
      if current_user.accounts.count  == 0
        redirect_to new_account_path
      else current_user.accounts.count > 1
        account = current_user.accounts.first
        site = current_user.accounts.first.site
        permission = current_user.owner_role(account.id) || current_user.permission_object(site.id)
        folder = permission.permission_role.can_see_all_folders ? site.folders.active.where(is_trash: false).first : current_user.folders(site).active.where(is_trash: false).first
        redirect_to account_site_folder_view_casts_path(account, site, folder)
      end
    else
      redirect_to new_user_session_path
  	end
  end

end