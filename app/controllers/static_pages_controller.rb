class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [ :landing_page ]
  def landing_page
    if current_user
      redirect_to calendar_path
    end
  end

  def stats
    @job_statuses = Job.unscoped.group("status").count
    next_bdays = (Date.today + 0.day).yday
    #next 5 bdays
    @people = Person.where("EXTRACT(DOY FROM date_of_birth) >= ?", next_bdays).order('EXTRACT (DOY FROM date_of_birth) ASC').first(5)
  end

  def calendar
    @jobs = Job.all
  end

end
