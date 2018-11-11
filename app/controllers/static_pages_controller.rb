class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [ :landing_page ]
  def landing_page
    if current_user
      redirect_to calendar_path
    end
  end

  def stats
    #company stats
    @total_earnings = Job.all.map(&:client_price_cents).sum
    @total_expences = Job.all.map(&:employee_price_cents).sum
    @net_income = @total_earnings - @total_expences

    #my_stats
    @my_total_earnings = Job.where(employee_id: current_user.person.employee.id).map(&:employee_price_cents).sum

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
