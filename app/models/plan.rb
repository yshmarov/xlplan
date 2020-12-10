class Plan
  PLANS = [:demo, :bronze, :silver, :gold]

  def self.options
    PLANS.map { |plan| [plan.capitalize, plan] }
  end
end
