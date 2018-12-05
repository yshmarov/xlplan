class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [ :landing_page ]

  def landing_page
    if current_user
      redirect_to dashboard_path
    end
  end

  def user_roles
  end

  def activity
    @activities = PublicActivity::Activity.all.reverse
  end

  def dashboard
    @activities = PublicActivity::Activity.limit(5).reverse
    @jobs = Job.mark_attendance
  end

  def calendar
    @jobs = current_user.employee.jobs
  end

end
