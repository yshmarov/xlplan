class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_tenant!
  ##    milia defines a default max_tenants, invalid_tenant exception handling
  ##    but you can override these if you wish to handle directly
  rescue_from ::Milia::Control::MaxTenantExceeded, :with => :max_tenants
  rescue_from ::Milia::Control::InvalidTenantAccess, :with => :invalid_tenant

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action  :prep_org_name

  #online?
  after_action :user_activity

  include PublicActivity::StoreController 

  #navbar search
  before_action :set_global_search_variable
  def set_global_search_variable
    @ransack_clients = Client.ransack(params[:clients_search], search_key: :clients_search)
  end

  #i18n
  before_action :set_locale
  private

  def callback_authenticate_tenant
    @org_name = ( Tenant.current_tenant.nil?  ?
      "MrJobber"   :
      Tenant.current_tenant.name 
    )
  end
  def prep_org_name()
    @org_name ||= "MrJobber"
  end

  #i18n
  def set_locale
    if current_user
      #I18n.locale = current_user.try(:locale) || I18n.default_locale
      I18n.locale = Tenant.current_tenant.try(:locale)  || I18n.default_locale
      #I18n.locale = Tenant.current_tenant.locale
      #I18n.locale = Tenant.current_tenant.locale.to_sym
      #I18n.locale = current_user.member.tenant.locale.to_sym
      #I18n.locale = current_user.member.tenant.locale.to_sym || I18n.default_locale
    else
      #I18n.locale = params[:locale] || I18n.default_locale
      locale = params[:locale].to_s.strip.to_sym
      I18n.locale = I18n.available_locales.include?(locale) ?
          locale :
          I18n.default_locale
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
