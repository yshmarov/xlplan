class WorkplacesController < ApplicationController
  def show
    @workplace = Workplace.friendly.find(params[:id])
    @members = Member.active.order('created_at ASC')
    #@jobs = @member.events
    @jobs = @workplace.jobs.includes(:event, :service, :member, :event => [:client])
    @memberquantity = 1
    @workplaces = Workplace.all
    render 'dashboard/calendar'
  end
end