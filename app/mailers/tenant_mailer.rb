class TenantMailer < ApplicationMailer
  default from: 'support@xlplan.com'

  def tenant_created
    mail(to: "yshmarov@gmail.com", subject: 'Tenant created')
  end
end
