class WorkplacesController < ApplicationController
  def show
    @member = Workplace.find(params[:id])
    @members = Member.active.order('created_at ASC')
    #@jobs = @member.events
    @jobs = @member.jobs.includes(:event, :service, :event => [:client, :workplace])
    @memberquantity = 1
    render 'dashboard/calendar'
  end
end