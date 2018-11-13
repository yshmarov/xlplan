class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [ :landing_page ]
  def landing_page
    if current_user
      redirect_to calendar_path
    end
  end

  def stats
    #company confirmed earning
    @confirmed_job_q = Job.where(status: [:confirmed, :confirmed_by_client]).count
    @total_confirmed_earnings = Job.where(status: [:confirmed, :confirmed_by_client]).map(&:client_due_price_cents).sum
    @total_confirmed_expences = Job.where(status: [:confirmed, :confirmed_by_client]).map(&:employee_due_price_cents).sum
    @total_confirmed_net_income = @total_confirmed_earnings - @total_confirmed_expences

    #company planned earnings
    @planned_job_q = Job.where(status: [:planned]).count
    @total_planned_earnings = Job.where(status: [:planned]).map(&:client_price_cents).sum
    @total_planned_expences = Job.where(status: [:planned]).map(&:employee_price_cents).sum
    @total_planned_net_income = @total_planned_earnings - @total_planned_expences

    #company loss stats
    @lost_job_q = Job.where(status: [:no_show, :rejected_by_us, :cancelled_by_client]).count
    @total_lost_earnings = Job.where(status: [:no_show, :rejected_by_us, :cancelled_by_client]).map(&:client_price_cents).sum
    @total_lost_expences = Job.where(status: [:no_show, :rejected_by_us, :cancelled_by_client]).map(&:employee_price_cents).sum
    @total_net_losses = @total_lost_earnings - @total_lost_expences

    #Job statuses
    @job_statuses = Job.unscoped.group("status").count
    #next 5 bdays
    next_bdays = (Date.today + 0.day).yday
    @people = Person.where("EXTRACT(DOY FROM date_of_birth) >= ?", next_bdays).order('EXTRACT (DOY FROM date_of_birth) ASC').first(5)
  end

  def calendar
    @jobs = Job.all
  end

end
