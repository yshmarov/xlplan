class StaticPagesController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [ :landing_page, :features, :pricing ]

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
end
