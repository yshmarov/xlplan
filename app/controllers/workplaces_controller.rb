class WorkplacesController < ApplicationController

  def index
    @workplaces = Workplace.all
    @members = Member.active.order('created_at ASC')
    @jobs = Job.includes(:service, :member, :event => [:client, :workplace])
    @memberquantity = @members.size
    render 'dashboard/calendar'
  end

  def show
    @workplace = Workplace.friendly.find(params[:id])
    @members = Member.active.order('created_at ASC')
    #@jobs = @member.events
    @jobs = @workplace.jobs.includes(:service, :member, :event => [:client])
    @memberquantity = 1
    @workplaces = Workplace.all
    render 'dashboard/calendar'
  end
end