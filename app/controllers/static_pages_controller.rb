class StaticPagesController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [ :landing_page, :features, :pricing, :privacy_policy, :terms_of_service, :security, :stats, :about ]

  def landing_page
    if current_user
      redirect_to calendar_path
    end
  end
  
  def features
  end
  
  def pricing
  end
  
  def about
  end
  
  def privacy_policy
  end
  
  def terms_of_service
  end
  
  def security
  end
  
  def stats
    if current_user
      redirect_to calendar_path
    end
    @ransack_tenants = Tenant.all.unscoped.search(params[:tenants_search], search_key: :tenants_search)
    @tenants = @ransack_tenants.result.paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
  end

  before_action :authenticate, only: :stats

  protected
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "passa" && password == "usera"
    end
  end

end
