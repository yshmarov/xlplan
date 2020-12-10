class ApplicationMailer < ActionMailer::Base
  # default from: 'support@xlplan.com'
  default from: "XLPLAN <support@xlplan.com>"
  # config.action_mailer.default_url_options = { host: 'xlplan.com' }
  layout "mailer"
end

# mail(
#  from: 'Sender Name <sender@example.com>',
#  to: 'Receiver Name <receiver@example.com>',
#  subject: 'Subject'
# )
