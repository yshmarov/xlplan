class InvitationsController < Devise::InvitationsController

  private
  def invite_params
    params.require(:user).permit(:invite, :email, :member_id)
  end

  def after_invite_path_for(user)
    members_path
  end
end 