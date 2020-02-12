class Leads::BookingWizardController < ApplicationController
  include Wicked::Wizard
  before_action :set_lead, only: [:show, :update]

  steps :select_service, :select_location, :select_member, :time, :personal_data

  def show
    case step
    when :select_service
      @favicon = 'Service'
      @services = Service.active.online_booking
      skip_step unless @services.any?
    when :select_location
      @favicon = 'Location'
      @locations = Location.active.online_booking
      skip_step unless @locations.any?
    when :select_member
      @favicon = 'Member'
      @members = Member.active.online_booking.order('created_at ASC').joins(:skills).where(skills: {service_category_id: @lead.service.service_category_id})
      skip_step unless @members.any?
    when :time
      @favicon = 'Time'
    when :personal_data
      @favicon = 'Client'
    end
    render_wizard
  end

  def update
    @lead = Lead.find(params[:lead_id])

    case step
    when :select_service
      @favicon = 'Service'
      @services = Service.online_booking.active
    when :select_location
      @favicon = 'Location'
      @locations = Location.active.online_booking
    when :select_member
      @favicon = 'Member'
      @members = Member.active.online_booking.order('created_at ASC').joins(:skills).where(skills: {service_category_id: @lead.service.service_category_id})
    when :time
      @favicon = 'Time'
    when :personal_data
      @favicon = 'Client'
    end

    params[:lead][:status] = step.to_s
    params[:lead][:status] = 'active' if step == steps.last
    #@lead.update_attributes(params[:lead])
    @lead.update lead_params

    render_wizard @lead
  end

  def finish_wizard_path
    #booking_show_path(@tenant)
    leads_path
  end

  private
  def lead_params
    params.require(:lead).permit(:first_name, :last_name, :phone_number, :email, :comment, 
              :location_id, :member_id, :service_id, 
              :starts_at, :coupon, :conditions_consent, :status)
  end
  def set_lead
    @lead = Lead.find params[:lead_id]
  end
end