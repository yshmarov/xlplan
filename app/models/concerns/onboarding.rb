module Onboarding

  def onboarding_percent
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
    steps = [:has_services?, :has_clients?, :has_events?, :has_transactions?]
    complete = steps.select{ |step| send(step) }
    percent = complete.length / steps.length.to_f * 100
    percent.round
  end
end