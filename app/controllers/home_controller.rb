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
    @q = Job.ransack(params[:q])
    @jobs = @q.result.includes(:location, :client, :member, :service).paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
  end

end
