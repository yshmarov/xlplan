class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_tenant!

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :user_activity

  include PublicActivity::StoreController 

  before_action :set_global_search_variable

  def set_global_search_variable
    @ransack_clients = Client.search(params[:clients_search], search_key: :clients_search)
  end


  private
    def user_not_authorized
      flash[:alert] = "You are not authorized to access this page."
      redirect_to(request.referrer || root_path)
    end

    def user_activity
      current_user.try :touch
    end

  #def current_user
  #  @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  #end
  #helper_method :current_user
  #hide_action :current_user

end
