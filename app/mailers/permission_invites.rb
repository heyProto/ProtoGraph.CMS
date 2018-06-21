class PermissionInvites < ApplicationMailer

  default from: FROM_EMAIL
  layout 'mailer'

  def invite(user, site, email)
  	@site = site
  	@user = user
  	mail(to: email, subject: "Invitation to collaborate on site: #{@site.slug}", tag: "organisation-invite-email")
  end

end
