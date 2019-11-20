class BookingWizardController < ApplicationController
  include Wicked::Wizard

  steps :select_service, :select_location, :select_member, :personal_data

  def show
    @lead = Lead.new
    #@lead = Lead.find(params[:lead_id])

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
    params[:lead][:status] = 'active' if step == steps.last
    @lead.update_attributes(params[:lead])

    #@members = Member.active.online_booking.order('created_at ASC')
    #@locations = Location.active.online_booking
    #@services = Service.online_booking.active

    render_wizard @lead
  end

  def create
    @lead = Lead.create
    redirect_to wizard_path(steps.first, lead_id: @lead.id)
  end

  def finish_wizard_path
    #booking_show_path(@tenant)
    leads_path
  end

end
