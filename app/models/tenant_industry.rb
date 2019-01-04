class TenantIndustry
  TENANT_INDUSTRIES = [:"beauty studio", :"private medicine", :"leisure and recreation", :"consulting", :"professional services"]
  
  def self.options
    TENANT_INDUSTRIES.map { |tenant_industry| [tenant_industry.capitalize, tenant_industry] }
  end
end