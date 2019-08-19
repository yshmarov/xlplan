# Preview all emails at http://localhost:3000/rails/mailers/tenant_mailer
class TenantMailerPreview < ActionMailer::Preview
  def tenant_created
    TenantMailer.tenant_created(Tenant.first).deliver_now
  end
end
