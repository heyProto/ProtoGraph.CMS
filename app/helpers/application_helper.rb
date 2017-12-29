module ApplicationHelper
  def is_admins_controller
    params[:controller].split("/")[0] == "admin"
  end
end
