class ChartsController < ApplicationController
  def monthly_events
    render json: Event.group_by_month(:starts_at).count
  end
end