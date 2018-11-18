class InvitationsController < Devise::InvitationsController

  private
  #def resource_params
    # params.require(:user).permit(:email,:invitation_token, :member_id)
  #end
  #def invite_params
  #  devise_parameter_sanitizer.sanitize(:invite, :member_id)
  #end

  def invite_params
  
    params.require(:user).permit(
      :invite,
      :email,
      :employee_id
    )
  end

  def after_invite_path_for(user)
    employees_path
  end

end