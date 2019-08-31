class BookingController < ApplicationController
  skip_before_action :authenticate_tenant!
  #skip_before_action :authenticate_tenant!, :only => [ :landing_page, :features, :pricing, :privacy_policy, :terms_of_service, :security, :stats, :about ]

  def list
    @tenants = Tenant.all.unscoped.order(created_at: :desc)
  end

  def show
    #Tenant.set_current_tenant( tenant.id )
    #@tenant = Tenant.find(Tenant.current_tenant_id)
    @tenant = Tenant.find(params[:id])
    Tenant.set_current_tenant( @tenant )
    
    @lead = Lead.new
    @leads = Lead.all

    #FOR CALENDAR
    #@jobs = Job.includes(:event, :service, :event => :client)
    @members = Member.active.order('created_at ASC')
    #@events = Event.today.includes(:client, :jobs, :jobs => [:service, :member])

    @locations = Location.all.order(events_count: :desc)
    @service_categories = ServiceCategory.all
  end

  def create_lead
    @tenant = Tenant.find(params[:id])
    Tenant.set_current_tenant( @tenant )
    @lead = Lead.new(lead_params)
    if @lead.save
      redirect_to booking_path(@lead.tenant), notice: 'Lead was successfully created.'
    else
      redirect_to booking_path(@lead.tenant), alert: 'You have missing fields.'
      #render :new
    end
  end

  private
    def lead_params
      params.require(:lead).permit(:first_name, :last_name, :phone_number, :email, :comment, :location_id, :member_id, :service_id)
    end

end