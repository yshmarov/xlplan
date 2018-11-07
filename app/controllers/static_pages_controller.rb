class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [ :landing_page ]
  def landing_page
    if current_user
      redirect_to dashboard_path
    end
  end

  def dashboard

  end

  def calendar
    @jobs = Job.all
  end

end
