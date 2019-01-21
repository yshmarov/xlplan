class Plan
  PLANS = [:basic, :professional, :enterprise]
  
  def self.options
    PLANS.map { |plan| [plan.capitalize, plan] }
  end
end