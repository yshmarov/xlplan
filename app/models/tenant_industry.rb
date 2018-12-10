class TenantIndustry
  TENANT_INDUSTRIES = [:massage, :dentist, :psychologist, :veterinary]
  
  def self.options
    TENANT_INDUSTRIES.map { |tenant_industry| [tenant_industry.capitalize, tenant_industry] }
  end
end