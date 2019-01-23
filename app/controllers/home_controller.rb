class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [ :landing_page ]

  def landing_page
    if current_user
      redirect_to calendar_path
    end
  end

  def activity
    @activities = PublicActivity::Activity.paginate(:page => params[:page], :per_page => 100).order("created_at DESC")
  end

  def start
  end

  def calendar
    #@jobs = Job.all
    @q = Event.ransack(params[:q])
    @events = @q.result.includes(:location, :client, :jobs)
  end

end
