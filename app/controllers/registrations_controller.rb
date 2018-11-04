class RegistrationsController < Devise::RegistrationsController

  before_action :any_users?, only: [:new, :create]
  #def invite_user
  #  @user = User.invite!(:email => params[:user][:email], :name => params[:user][:name])
  #  render :json => @user
  #end
  protected

  def any_users?
    if User.count != 0
      redirect_to new_user_session_path
    end
    #if ((User.count != 0) & (user_signed_in?))
    #  redirect_to root_path
    #elsif User.count > 0
    #  redirect_to new_user_session_path
    #end  
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :person_id)
  end

  def account_update_params
    #params.require(:user).permit(:time_zone, :email, :password, :password_confirmation, :current_password, :person_id)
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :person_id)
  end

end