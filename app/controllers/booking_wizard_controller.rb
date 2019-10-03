class BookingWizardController < ApplicationController
  include Wicked::Wizard

  #automatically skip step if no online_booking Members/ Locations/ Services? - no. just "any Member/Location/Service button will be visible"
  steps :select_service, :select_location, :select_member, :personal_data
  #steps :personal_data, :select_service

  def show
    #@user = current_user
    @lead = Lead.new
    render_wizard
  end

  def update
    @user = current_user
    @user.update_attributes(params[:user])
    render_wizard @user
  end

  def finish_wizard_path
    leads_path
    #lead_path(current_user)
  end
#
#
#  def update
#    @user = current_user
#    case step
#    when :confirm_password
#      @user.update_attributes(params[:user])
#    end
#    sign_in(@user, bypass: true) # needed for devise
#    render_wizard @user
#  end
#
#private
#
#  def redirect_to_finish_wizard
#    redirect_to root_url, notice: "Thank you for signing up."
#  end
#
end

  #select_service
  
  #select_location
  #next_wizard_path
  
  #select_member
  
  
  #personal_data
  
