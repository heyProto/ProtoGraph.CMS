module ApplicationHelper
  def is_admins_controller
    params[:controller].split("/")[0] == "admin"
  end
  
  def folder_name_(f)
    if f.vertical.present?
        if f.vertical.name_html.present?
            return f.vertical.name_html  + ": " + f.name.titleize
        else
            return f.vertical.name + ": " + f.name.titleize
        end
      else
        return f.name.titleize
    end
  end
  
  def folder_name_trunc_(f)
    if f.vertical.present?
        if f.vertical.name_html.present?
            return f.vertical.name  + ": " + f.name.titleize
        else
            return f.vertical.name + ": " + f.name.titleize
        end
      else
        return f.name.titleize
    end
  end
  
end
