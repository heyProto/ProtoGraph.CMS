module UsersHelper

    def avatar_url(e, size=30)
        str = e.present? ? e.downcase : ""
        "https://gravatar.com/avatar/#{Digest::MD5.hexdigest(str)}.png?s=#{size}"
    end

end