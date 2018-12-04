class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [ :landing_page ]

  def landing_page
    if current_user
      redirect_to my_calendar_path
    end
  end

  def role_description
  end

  def activity
    @activities = PublicActivity::Activity.all.reverse
  end

  def my_calendar
    @jobs = current_user.employee.jobs
  end

end
