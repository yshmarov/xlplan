class StaticPagesController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [ :landing_page, :features, :pricing, :stats ]

  def landing_page
    if current_user
      redirect_to calendar_path
    end
  end

  def features
    if current_user
      redirect_to calendar_path
    end
  end

  def pricing
    if current_user
      redirect_to calendar_path
    end
  end

  def stats
    if current_user
      redirect_to calendar_path
    end
  end

  before_action :authenticate, only: :stats

  protected
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "passa" && password == "usera"
    end
  end

end
