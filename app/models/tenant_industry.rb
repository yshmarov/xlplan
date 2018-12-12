class TenantIndustry
  TENANT_INDUSTRIES = [:beauty_studio, :private_medicine, :leisure_and_recreation, :consulting, :professional_services]
  
  def self.options
    TENANT_INDUSTRIES.map { |tenant_industry| [tenant_industry.capitalize, tenant_industry] }
  end
end