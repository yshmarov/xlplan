class ChartsController < ApplicationController
  def monthly_events
    render json: Event.group_by_month(:starts_at).count, prefix: "#{Tenant.current_tenant.default_currency.upcase} "
  end

  def finances_client_due_price_per_month
    render json: Event.group_by_month(:starts_at, format: "%b %Y").sum("client_price/100")
  end

  def members_jobs_per_member_per_month_quantity
    render json: Member.all.map { |member| {name: member.full_name, data: member.jobs.joins(:event).where(events: {status: [:confirmed]}).group_by_month('events.starts_at').count} }
  end
  def members_confirmed_client_price_per_month
    render json: Member.all.map { |member| {name: member.full_name, data: member.jobs.joins(:event).where(events: {status: [:confirmed]}).group_by_month('events.starts_at').sum('client_due_price / 100')}}
  end
  def members_confirmed_earnings_per_month  
    render json: Member.all.map { |member| {name: member.full_name, data: member.jobs.joins(:event).where(events: {status: [:confirmed]}).group_by_month('events.starts_at').sum('member_due_price / 100')}}
  end
end