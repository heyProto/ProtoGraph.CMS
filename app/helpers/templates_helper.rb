module TemplatesHelper

    def show_lock(s, str)
        if s
            return ""
        else
            return "#{str} <i class='lock icon' style='color: gold; font-size: 15px;'></i>"
        end
    end

    def next_status(s)
        s == "Draft" ? "Ready to Publish" : s == "Ready to Publish" ? "Published" : nil
    end

end