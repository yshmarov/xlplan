class StaticPagesController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [:landing_page, :features, :pricing, :privacy_policy, :terms_of_service, :security, :stats]

  def landing_page
    if current_user
      redirect_to calendar_member_path(id: current_user.member.id)
    end
  end

  def features
  end
  
  def pricing
  end

  def privacy_policy
  end
  
  def terms_of_service
  end
  
  def security
  end

  before_action :authenticate, only: :stats
  
  def stats
    #if current_user
    #  redirect_to calendar_path
    #end
    @ransack_tenants = Tenant.all.unscoped.search(params[:tenants_search], search_key: :tenants_search)
    @tenants = @ransack_tenants.result.paginate(:page => params[:page], :per_page => 50).order("created_at DESC")
  end

  protected
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "passa" && password == "usera"
    end
  end
end