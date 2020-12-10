class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # protect_from_forgery

  before_action :authenticate_tenant!
  ##    milia defines a default max_tenants, invalid_tenant exception handling
  ##    but you can override these if you wish to handle directly
  rescue_from ::Milia::Control::MaxTenantExceeded, with: :max_tenants
  rescue_from ::Milia::Control::InvalidTenantAccess, with: :invalid_tenant

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include PublicActivity::StoreController # save current_user using gem public_activity

  before_action :set_locale
  before_action :set_global_variables, if: :user_signed_in?
  # after_action :user_activity, if: :user_signed_in?
  around_action :set_time_zone, if: :user_signed_in?
  before_action :callback_authenticate_tenant

  private

  # i18n
  # def set_locale
  #  parsed_locale = params[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/)[0]
  #  I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  # end
  def set_locale
    if current_user
      lang = Tenant.current_tenant.try(:locale) || I18n.default_locale
    elsif params["locale"].present?
      lang = params["locale"].to_sym
      session["locale"] = lang
      redirect_to root_path
    elsif session["locale"].present?
      lang = session["locale"]
    else
      lang = "en"
    end
    I18n.locale = if I18n.available_locales.map(&:to_s).include?(lang)
      lang
    else
      "en"
    end
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  # pundit
  def user_not_authorized
    flash[:alert] = "You are not authorized to access this page."
    redirect_to(request.referrer || root_path)
  end

  # navbar search
  def set_global_variables
    @tenant = Tenant.current_tenant
    @ransack_clients = Client.ransack(params[:clients_search], search_key: :clients_search)
    @event_close_count = Event.close.count
    @client_debtors_count = Client.debtors.count
    @lead_active_no_client_count = Lead.active.has_no_client.count
  end

  # online?
  # def user_activity
  #  current_user.try :touch
  # end

  # GEM MILIA
  def callback_authenticate_tenant
    @org_name = (Tenant.current_tenant.nil? ?
      "XLPLAN" :
      Tenant.current_tenant.name
                )
  end

  def prep_org_name
    @org_name ||= "CRM for service business management"
  end
end
