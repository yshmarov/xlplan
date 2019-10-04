class BookingWizardController < ApplicationController
  include Wicked::Wizard

  steps :select_service, :select_location, :select_member, :personal_data

  def show
    #@user = current_user
    @lead = Lead.new

    case step
    when :select_service
      @services = Service.online_booking.active
      skip_step unless @services.any?
    when :select_location
      @locations = Location.active.online_booking.order(events_count: :desc)
      skip_step unless @locations.any?
    when :select_member
      @members = Member.active.online_booking.order('created_at ASC')
      skip_step unless @members.any?
    end
    render_wizard
  end

  def update
    #@user = current_user
    #@lead.save
    @lead = Lead.new
    #@lead.attributes = params[:lead]
    #@lead.update_attributes(params[:lead])

    @members = Member.active.online_booking.order('created_at ASC')
    @locations = Location.active.online_booking.order(events_count: :desc)
    @services = Service.online_booking.active

    render_wizard @lead
  end

  def create
    @lead = Lead.create
    redirect_to wizard_path(steps.first, lead_id: @lead.id)
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
  
