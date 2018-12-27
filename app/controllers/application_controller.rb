class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_tenant!

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  #online?
  after_action :user_activity
  before_action :set_locale

  ##    milia defines a default max_tenants, invalid_tenant exception handling
  ##    but you can override these if you wish to handle directly
  rescue_from ::Milia::Control::MaxTenantExceeded, :with => :max_tenants
  rescue_from ::Milia::Control::InvalidTenantAccess, :with => :invalid_tenant
  
  include PublicActivity::StoreController 

  #navbar search
  before_action :set_global_search_variable
  def set_global_search_variable
    @ransack_clients = Client.search(params[:clients_search], search_key: :clients_search)
  end


  private
    #i18n
    def set_locale
      if current_user
        #I18n.locale = current_user.try(:locale) || I18n.default_locale
        I18n.locale = Tenant.current_tenant.try(:locale)  || I18n.default_locale
        #I18n.locale = Tenant.current_tenant.locale
        #I18n.locale = Tenant.current_tenant.locale.to_sym
        #I18n.locale = current_user.member.tenant.locale.to_sym
        #I18n.locale = current_user.member.tenant.locale.to_sym || I18n.default_locale
      end
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to access this page."
      redirect_to(request.referrer || root_path)
    end

    def user_activity
      current_user.try :touch
    end

end
