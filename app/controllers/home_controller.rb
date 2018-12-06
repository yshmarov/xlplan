class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [ :landing_page ]

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
    @jobs = Job.mark_attendance.where(employee_id: current_user.employee.id)
    @total_confirmed_earnings = Job.is_confirmed.where('created_at >= ?', 1.month.ago).map(&:client_due_price_cents).sum
  end

  def calendar
    @jobs = current_user.employee.jobs
  end

end
