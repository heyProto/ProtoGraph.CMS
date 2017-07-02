class ApplicationMailer < ActionMailer::Base
  default from: FROM_EMAIL
  layout 'mailer'
end
