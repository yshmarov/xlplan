module Onboarding

  def onboarding_percent
    def has_locations?
      Location.any?
    end
    def has_service_categories?
      ServiceCategory.any?
    end
    def has_services?
      Service.any?
    end
    def has_clients?
      Client.any?
    end
    def has_events?
      Event.any?
    end
    def has_transactions?
      Transaction.any?
    end
    steps = [:has_locations?, :has_service_categories?, :has_services?, :has_clients?, :has_events?, :has_transactions?]
    complete = steps.select{ |step| send(step) }
    percent = complete.length / steps.length.to_f * 100
    percent.round
  end

  #def onboarding_percent
  #  if Location.any?
  #    l = 25
  #  else
  #    l = 0
  #  end
  #  if Service.any?
  #    s = 25
  #  else
  #    s = 0
  #  end
  #  if Client.any?
  #    c = 25
  #  else
  #    c = 0
  #  end
  #  if Event.any?
  #    e = 25
  #  else
  #    e = 0
  #  end
  #  l+s+c+e
  #end

end
