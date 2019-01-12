class StatsController < ApplicationController
  def finances

    #company confirmed earning
    @confirmed_hours_worked = (Job.is_confirmed.map(&:service_duration).sum)/60.to_d
    @confirmed_job_q = Job.is_confirmed.count
    @total_confirmed_earnings = Job.is_confirmed.map(&:client_due_price_cents).sum
    @total_confirmed_expences = Job.is_confirmed.map(&:member_due_price_cents).sum
    @total_confirmed_net_income = @total_confirmed_earnings - @total_confirmed_expences

    #company planned earnings
    @planned_hours_worked = (Job.is_planned.map(&:service_duration).sum)/60.to_d
    @planned_job_q = Job.is_planned.count
    @total_planned_earnings = Job.is_planned.map(&:client_price_cents).sum
    @total_planned_expences = Job.is_planned.map(&:member_price_cents).sum
    @total_planned_net_income = @total_planned_earnings - @total_planned_expences

    #company loss stats
    @lost_hours_worked = (Job.is_cancelled.map(&:service_duration).sum)/60.to_d
    @lost_job_q = Job.is_cancelled.count
    @total_lost_earnings = Job.is_cancelled.map(&:client_price_cents).sum
    @total_lost_expences = Job.is_cancelled.map(&:member_price_cents).sum
    @total_net_losses = @total_lost_earnings - @total_lost_expences

    #average paycheck
    @average_confirmed_earnings = Job.is_confirmed.average(:client_due_price).to_i/100
  end

  def clients
    #pie charts
    @client_gender_pie = Client.unscoped.group("gender").count
    @client_status_pie = Client.unscoped.group("status").count
    #next 5 bdays
    next_bdays = (Date.today + 0.day).yday
    @clients = Client.where("EXTRACT(DOY FROM date_of_birth) >= ?", next_bdays).order('EXTRACT (DOY FROM date_of_birth) ASC').first(5)
  end

  def members
    #performance vs others
    @members = Member.all
  end

  def appointments
    #pie charts
    @appointment_status_pie = Appointment.unscoped.group("status").count
    #appointment Q per month (only confirmed)
    @monthly_appointments = Appointment.is_confirmed.map { |appointment| [Date::MONTHNAMES[appointment.starts_at.month], appointment.starts_at.year].join(' ') }.each_with_object(Hash.new(0)) { |month_year, counts| counts[month_year] += 1 }
  end

  def services
    #highest Q
    #highest earnings
    @services = Service.all
  end

  def locations
    @locations = Location.all
  end

end
