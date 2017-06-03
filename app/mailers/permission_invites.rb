class PermissionInvites < ApplicationMailer

  default from: 'from@example.com'
  layout 'mailer'

  def invite(user, account, email)
  	@account = account
  	@user = user
  	mail(to: email, subject: "Invitation to collaborate on account: #{@account.slug}", tag: "organisation-invite-email")
  end

end
