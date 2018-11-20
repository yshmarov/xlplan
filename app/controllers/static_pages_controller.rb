class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [ :landing_page ]
  def landing_page
    if current_user
      redirect_to calendar_path
    end
  end

  def job_stats
    #company confirmed earning
    @confirmed_hours_worked = (Job.is_confirmed.map(&:service_duration).sum)/60.to_d
    @confirmed_job_q = Job.is_confirmed.count
    @total_confirmed_earnings = Job.is_confirmed.map(&:client_due_price_cents).sum
    @total_confirmed_expences = Job.is_confirmed.map(&:employee_due_price_cents).sum
    @total_confirmed_net_income = @total_confirmed_earnings - @total_confirmed_expences

    #company planned earnings
    @planned_hours_worked = (Job.is_planned.map(&:service_duration).sum)/60.to_d
    @planned_job_q = Job.is_planned.count
    @total_planned_earnings = Job.is_planned.map(&:client_price_cents).sum
    @total_planned_expences = Job.is_planned.map(&:employee_price_cents).sum
    @total_planned_net_income = @total_planned_earnings - @total_planned_expences

    #company loss stats
    @lost_hours_worked = (Job.is_cancelled.map(&:service_duration).sum)/60.to_d
    @lost_job_q = Job.is_cancelled.count
    @total_lost_earnings = Job.is_cancelled.map(&:client_price_cents).sum
    @total_lost_expences = Job.is_cancelled.map(&:employee_price_cents).sum
    @total_net_losses = @total_lost_earnings - @total_lost_expences
  end

  def other_stats
    #pie charts
    @job_status_pie = Job.unscoped.group("status").count
    @job_service_pie = Job.unscoped.group("service_id").count
    @client_sex_pie = Client.unscoped.group("sex").count
    @client_status_pie = Client.unscoped.group("status").count

    #average paycheck
    @average_confirmed_earnings = Job.is_confirmed.average(:client_due_price).to_i/100

    #job Q per month (only confirmed)
    @monthly_jobs = Job.is_confirmed.map { |job| [Date::MONTHNAMES[job.starts_at.month], job.starts_at.year].join(' ') }.each_with_object(Hash.new(0)) { |month_year, counts| counts[month_year] += 1 }

    #next 5 bdays
    next_bdays = (Date.today + 0.day).yday
    @clients = Client.where("EXTRACT(DOY FROM date_of_birth) >= ?", next_bdays).order('EXTRACT (DOY FROM date_of_birth) ASC').first(5)
  end

  def calendar
    @jobs = Job.all
  end

end
