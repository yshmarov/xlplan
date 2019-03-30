class DashboardController < ApplicationController
  def activity
    @activities = PublicActivity::Activity.paginate(:page => params[:page], :per_page => 100).order("created_at DESC").where(tenant_id: Tenant.current_tenant.id)
  end

  def start
  end

  def calendar
    @jobs = Job.includes(:event, :service, :event => :client)
    @members = Member.active
    #@events = Event.includes(:client, :jobs, :jobs => [:service, :member])
  end

  #def my_calendar
  #  @jobs = Job.where(member_id: current_user.member.id).includes(:event, :service, :member, :event => :client)
  #end
end
