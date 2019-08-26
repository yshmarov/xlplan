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
    #@jobs = Job.includes(:event, :service, :event => :client)
    @members = Member.active.order('created_at ASC')
    @events = Event.today.includes(:client, :jobs, :jobs => [:service, :member])

  end
end
