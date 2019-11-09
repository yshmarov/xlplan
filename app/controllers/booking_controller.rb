class BookingController < ApplicationController
  skip_before_action :authenticate_tenant!
  #skip_before_action :authenticate_tenant!, :only => [ :landing_page, :features, :pricing, :privacy_policy, :terms_of_service, :security, :stats, :about ]

  def index
    #@tenants = Tenant.online_booking.order(created_at: :desc)
    @q = Tenant.ransack(params[:q])
    @tenants = @q.result.online_booking.order(created_at: :desc)
  end

  def show
    #Tenant.set_current_tenant( tenant.id )
    #@tenant = Tenant.find(Tenant.current_tenant_id)
    @tenant = Tenant.find(params[:id])
    Tenant.set_current_tenant( @tenant )

    unless @tenant.online_booking
      redirect_to booking_index_path, alert: 'This page is currently offline.'
    end

    @lead = Lead.new
    #@leads = Lead.all

    #FOR CALENDAR
    #@jobs = Job.includes(:event, :service, :event => :client)
    #@events = Event.today.includes(:client, :jobs, :jobs => [:service, :member])
    
    #for online booking & calendar
    @members = Member.active.online_booking.order('created_at ASC')

    @locations = Location.active.online_booking.order(events_count: :desc)

    #show service categories that have a service that has online booking
    @service_categories = ServiceCategory.distinct.joins(:services).where(services: {online_booking: true, active: true})
    #used only for the lead form
    @services = Service.online_booking.active
  end
  
  def new_booking
    @lead = Lead.new
    @tenant = Tenant.find(params[:id])
    Tenant.set_current_tenant( @tenant )
    #@lead = Lead.new(lead_params)

    #for form
    @members = Member.active.online_booking.order('created_at ASC')
    @locations = Location.active.online_booking.order(events_count: :desc)
    @services = Service.online_booking.active
    @ip_address = request.remote_ip
    @referer = request.referer
  end

  def create_booking
    @tenant = Tenant.find(params[:id])
    Tenant.set_current_tenant( @tenant )
    @lead = Lead.new(lead_params)

    #WORKS GOOD BUT DOES NOT RENDER ERRORS
    #if @lead.save
    #  redirect_to booking_show_path(@lead.tenant), notice: 'Lead was successfully created.'
    #else
    #  redirect_to booking_show_path(@lead.tenant), alert: 'You have missing fields.'
    #  #render :new
    #end
    respond_to do |format|
      #if @lead.save
      if verify_recaptcha(model: @lead) && @lead.save
        format.html { redirect_to booking_show_path(@lead.tenant), notice: 'Lead was successfully created.' }
        format.json { render :show, status: :created, location: @lead }
      else
        @members = Member.active.online_booking.order('created_at ASC')
        @locations = Location.active.online_booking.order(events_count: :desc)
        @services = Service.online_booking
        format.html { render :new_booking }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def lead_params
      params.require(:lead).permit(:first_name, :last_name, :phone_number, :email, :comment,
                :location_id, :member_id, :service_id, :starts_at, :coupon, :conditions_consent)
    end
end