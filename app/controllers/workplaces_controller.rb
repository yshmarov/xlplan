class WorkplacesController < ApplicationController
  def show
    @member = Workplace.find(params[:id])
    @members = Member.active.order('created_at ASC')
    #@jobs = @workplace.jobs.includes(:event, :service, :event => [:client, :location])
    #@jobs = @workplace.jobs.includes(:event, :service, :event => [:client, :location])
    @memberquantity = 1
    render 'members/calendar'
  end
end