class StaticPagesController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [:landing_page, :stats]

  def landing_page
    if current_user
      redirect_to calendar_list_members_path
    end
  end

  before_action :authenticate, only: :stats
  def stats
    @ransack_tenants = Tenant.all.search(params[:tenants_search], search_key: :tenants_search)
    @tenants = @ransack_tenants.result.order("created_at DESC")
  end

  protected
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "passa" && password == "usera"
    end
  end
end