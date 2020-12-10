class TenantMailer < ApplicationMailer
  def tenant_created(tenant)
    @tenant = tenant
    mail(to: "yshmarov@gmail.com", subject: "Tenant created")
  end
end
