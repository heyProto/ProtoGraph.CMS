module ApplicationHelper
  def is_admins_controller
    params[:controller].split("/")[0] == "admin"
  end

  def folder_name_(f)
    if f.vertical.present?
      return f.vertical.name + ": " + f.name.titleize
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

  def page_status(p)
    case p.status
      when "Draft: Planning"
        return "<span class='badge badge-secondary article-status-draft--planning'>#{p.status}</span>"
      when "Draft: Ready to write"
        return "<span class='badge badge-secondary article-status-draft--ready-to-write'>#{p.status}</span>"
      when "Draft: Ready to review"
        return "<span class='badge badge-secondary article-status-draft--ready-to-review'>#{p.status}</span>"
      when "Draft: Ready to Assemble"
        return "<span class='badge badge-secondary article-status-draft--ready-to-assemble'>#{p.status}</span>"
      when "Draft: Ready to Package"
        return "<span class='badge badge-secondary article-status-draft--ready-to-package'>#{p.status}</span>"
      when "Draft: Ready to Publish"
        return "<span class='badge badge-secondary article-status-draft--ready-to-publish'>#{p.status}</span>"
      when "Published: Unlisted"
        return "<span class='badge badge-secondary article-status-published--unlisted'>#{p.status}</span>"
      when "Published: Public"
        return "<span class='badge badge-secondary article-status-published--public'>#{p.status}</span>"
    end
  end

end
