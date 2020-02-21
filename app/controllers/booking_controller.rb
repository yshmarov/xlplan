class BookingController < ApplicationController
  skip_before_action :authenticate_tenant!
  before_action :set_tenant, only: [:show, :new, :create]

  def index
    @q = Tenant.ransack(params[:q])
    @tenants = @q.result.online_booking.not_blocked.order(created_at: :desc)
    #@tenants = @q.result.includes(:services).online_booking.not_blocked.order(created_at: :desc)
    #order by events.count
  end

  def show
    unless current_user
      if @tenant.online_booking == false || @tenant.plan == 'blocked'
        redirect_to booking_path, alert: 'This page is currently offline.'
      end
    end
    @members = Member.active.online_booking.order('created_at ASC')
    @locations = Location.active.online_booking
    @service_categories = ServiceCategory.distinct.joins(:services).where(services: {online_booking: true, active: true}) #show service categories that have a service that has online booking
  end
  
  def new
    @lead = Lead.new

    @members = Member.active.online_booking.order('created_at ASC')
    @locations = Location.active.online_booking
    @services = Service.online_booking.active
    @ip_address = request.remote_ip
    @referer = request.referer
  end

  def create
    @lead = Lead.new(lead_params)
    @lead.status = 'classic_form'
    respond_to do |format|
      #if @lead.save
      if verify_recaptcha(model: @lead) && @lead.save
        format.html { redirect_to booking_show_path(@lead.tenant), notice: 'Lead was successfully created.' }
        format.json { render :show, status: :created, location: @lead }
      else
        @members = Member.active.online_booking.order('created_at ASC')
        @locations = Location.active.online_booking
        @services = Service.online_booking
        format.html { render :new }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_tenant
      @tenant = Tenant.find(params[:id])
      Tenant.set_current_tenant( @tenant )
    end

    def lead_params
      params.require(:lead).permit(:first_name, :last_name, :phone_number, :email, :comment,
              :location_id, :member_id, :service_id,
              :starts_at, :coupon, :conditions_consent)
    end
end