class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [ :landing_page ]

  def landing_page
    if current_user
      redirect_to calendar_path
    end
  end

  def activity
    @activities = PublicActivity::Activity.all.reverse
  end

  def start
  end

  def calendar
    @q = Appointment.ransack(params[:q])
    @appointments = @q.result.includes(:location, :client, :member)
  end

end
