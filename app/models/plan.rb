class Plan
  PLANS = [:bronze, :silver, :gold]
  
  def self.options
    PLANS.map { |plan| [plan.capitalize, plan] }
  end
end