class Leads::BookingWizardController < ApplicationController
  #before_action :set_lead
  
  include Wicked::Wizard

  steps :select_location, :select_service, :select_member, :personal_data

  def show
    #@lead = Lead.new
    @lead = Lead.find(params[:lead_id])

    case step
    when :select_service
      @services = Service.online_booking.active
      skip_step unless @services.any?
    when :select_location
      @locations = Location.active.online_booking
      skip_step unless @locations.any?
    when :select_member
      @members = Member.active.online_booking.order('created_at ASC')
      skip_step unless @members.any?
    end
    render_wizard
  end

  def update
    @lead = Lead.find(params[:lead_id])
    #params[:lead][:status] = 'active' if step == steps.last
    #@lead.update_attributes(params[:lead])

    #@members = Member.active.online_booking.order('created_at ASC')
    #@locations = Location.active.online_booking
    #@services = Service.online_booking.active

    #@lead = Lead.find(params[:lead_id])
    #params[:lead][:status] = step.to_s
    #params[:lead][:status] = 'active' if step == steps.last
    #@lead.update_attributes(params[:lead])

    #@lead.step = step
    @lead.update lead_params

    render_wizard @lead
  end

  def finish_wizard_path
    #booking_show_path(@tenant)
    leads_path
  end

  #def update
  #  @lead = current_lead
  #  case step
  #  when :confirm_password
  #    @lead.update_attributes(lead_params)
  #  end
  #  sign_in(@lead, bypass: true) # needed for devise
  #  render_wizard @lead
  #end
  #
  #private
  #def lead_params
  #  params.require(:lead)
  #        .permit(:email, :current_password) # ...
  #end

  private
  def lead_params
    params.require(:lead).permit(:first_name, :last_name, :phone_number, :email, :comment, :location_id, :member_id, :service_id, :starts_at, :coupon, :conditions_consent)
  end

  def set_lead
    @lead = Lead.find params[:lead_id]
  end
end