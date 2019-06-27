class TenantMailer < ApplicationMailer

  def tenant_created
    mail(to: "yshmarov@gmail.com", subject: 'Tenant created')
  end
end
