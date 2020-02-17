class Leads::BookingWizardController < ApplicationController
  include Wicked::Wizard
  before_action :set_lead, only: [:show, :update, :finish_wizard_path]
  before_action :set_progress, only: [:show, :update, :finish_wizard_path]

  steps :select_service, :select_location, :select_member, :select_time, :personal_data

  def show
    case step
    when :select_service
      @favicon = 'Service'
      @services = Service.active.online_booking.joins(:skills).distinct
      skip_step unless @services.any?
    when :select_location
      @favicon = 'Location'
      @locations = Location.active.online_booking.order('created_at ASC').joins(:skills).where(skills: {service_category_id: @lead.service.service_category_id})
      skip_step unless @locations.any?
    when :select_member
      @favicon = 'Member'
      @members = Member.active.online_booking.order('created_at ASC').joins(:skills).where(skills: {service_category_id: @lead.service.service_category_id})
      skip_step unless @members.any?
    when :select_time
      @favicon = 'Time'
    when :personal_data
      @favicon = 'Client'
    end
    render_wizard
  end

  def update
    @lead = Lead.friendly.find(params[:lead_id])

    case step
    when :select_service
      @favicon = 'Service'
      @services = Service.online_booking.active
    when :select_location
      @favicon = 'Location'
      @locations = Location.active.online_booking.order('created_at ASC').joins(:skills).where(skills: {service_category_id: @lead.service.service_category_id})
    when :select_member
      @favicon = 'Member'
      @members = Member.active.online_booking.order('created_at ASC').joins(:skills).where(skills: {service_category_id: @lead.service.service_category_id})
    when :select_time
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
    def set_progress
      if wizard_steps.any? && wizard_steps.index(step).present?
        @progress = ((wizard_steps.index(step) + 1).to_d / wizard_steps.count.to_d) * 100
      else
        @progress = 0
      end
    end
    
    def set_lead
      @lead = Lead.friendly.find params[:lead_id]
    end

    def lead_params
      params.require(:lead).permit(:first_name, :last_name, :phone_number, :email, :comment, 
                :location_id, :member_id, :service_id, 
                :starts_at, :coupon, :conditions_consent, :status)
    end
end