class DashboardController < ApplicationController
  def activity
    @activities = PublicActivity::Activity.paginate(:page => params[:page], per_page: 50).order("created_at DESC").where(tenant_id: Tenant.current_tenant.id)
  end

  def start
  end

  def calendar
    @members = Member.active.order('created_at ASC')
    @locations = Location.all.includes(:workplaces)
    @jobs = Job.includes(:service, :member, :event => [:client, :workplace])
    render 'dashboard/calendar'
  end

  def client_stats
    authorize Tenant, :show?
  end

  def member_stats
    authorize Tenant, :show?
    @members = Member.all
  end

  def member_salary
    authorize Tenant, :show?
    @members = Member.all #for select
    if params.has_key?(:select)
      @start_date = (params[:select][:year] + "-" + params[:select][:month] + "-" + 01.to_s).to_datetime.beginning_of_month
      @end_date = @start_date.end_of_month
      @member = params[:member]

      @jobs = Job.joins(:event, :service, :service => :service_category, :event => :client).where(events: {:starts_at => @start_date..@end_date}).where(member_id: @member).order(starts_at: :asc)
      #did not try this
      #@jobs = Job.where('starts_at BETWEEN ? AND ?', @selected_date.beginning_of_day, @selected_date.end_of_day)
      
      @member_select = Member.where(id: @member) #for productivity
      
      #confirmed
      @confirmed_job_q = @jobs.where(events: {status: ['confirmed', 'no_show_refunded']}).count
      @confirmed_hours_worked = (@jobs.where(events: {status: ['confirmed', 'no_show_refunded']}).map(&:service_duration).sum)/60.to_d
      @total_confirmed_earnings = @jobs.where(events: {status: ['confirmed', 'no_show_refunded']}).map(&:client_due_price_cents).sum
      @total_confirmed_expences = @jobs.where(events: {status: ['confirmed', 'no_show_refunded']}).map(&:member_due_price_cents).sum
      #cancelled
      @lost_job_q = @jobs.where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).count
      @lost_hours_worked = (@jobs.where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).map(&:service_duration).sum)/60.to_d
      @total_lost_earnings = @jobs.where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).map(&:client_price_cents).sum
      @total_lost_expences = @jobs.where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).map(&:member_price_cents).sum
    else
      @jobs = Job.joins(:event, :service, :service => :service_category, :event => :client).where(events: {:starts_at => Time.now.beginning_of_month..Time.now.end_of_month}).where(member_id: 0)
    end
  end

  def event_stats
    authorize Tenant, :show?
    #average paycheck
    @average_confirmed_earnings = Job.joins(:event).where(events: {status: ['confirmed', 'no_show_refunded']}).average(:client_due_price).to_i/100
    if params.has_key?(:select)
      @start_date = (params[:select][:year] + "-" + params[:select][:month] + "-" + 01.to_s).to_datetime
      @end_date = @start_date.end_of_month
      @events = Event.where("starts_at BETWEEN ? AND ?",@start_date, @end_date)
    else
      @events = Event.where("starts_at BETWEEN ? AND ?", Time.now.beginning_of_month, Time.now.end_of_month)
    end
  end
  
  def transaction_stats
    authorize Tenant, :show?
    if params.has_key?(:select)
      @start_date = (params[:select][:year] + "-" + params[:select][:month] + "-" + 01.to_s).to_datetime.beginning_of_month
      @end_date = @start_date.end_of_month
      @transactions = Transaction.where("created_at BETWEEN ? AND ?",@start_date, @end_date)
    else
      @transactions = Transaction.where("created_at BETWEEN ? AND ?", Time.now.beginning_of_month, Time.now.end_of_month)
    end
  end

  def lead_stats
    authorize Tenant, :show?
    @leads = Lead.all
  end
end