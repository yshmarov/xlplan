class DashboardController < ApplicationController
  def activity
    @activities = PublicActivity::Activity.paginate(:page => params[:page], per_page: 50).order("created_at DESC").where(tenant_id: Tenant.current_tenant.id)
  end

  def dashboard
    @events_today = Event.where("created_at >= ?", Time.zone.now.beginning_of_day).count
    @clients_today = Client.where("created_at >= ?", Time.zone.now.beginning_of_day).count
    @payments_today = Transaction.where("created_at >= ?", Time.zone.now.beginning_of_day).count
  end

  def start
  end

  def calendar
    @members = Member.active.order('created_at ASC')
    @jobs = Job.includes(:service, :member, :event => [:client, :workplace])
    @memberquantity = @members.size
    @workplaces = Workplace.all
  end

  def client_stats
    if current_user.has_role?(:admin)
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end

  def member_stats
    if current_user.has_role?(:admin)
      @members = Member.all
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end

  def member_salary
    if current_user.has_role?(:admin)
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
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end

  def event_stats
    if current_user.has_role?(:admin)
      #average paycheck
      @average_confirmed_earnings = Job.joins(:event).where(events: {status: ['confirmed', 'no_show_refunded']}).average(:client_due_price).to_i/100
      if params.has_key?(:select)
        @start_date = (params[:select][:year] + "-" + params[:select][:month] + "-" + 01.to_s).to_datetime
        @end_date = @start_date.end_of_month
        @events = Event.where("starts_at BETWEEN ? AND ?",@start_date, @end_date)
      else
        @events = Event.where("starts_at BETWEEN ? AND ?", Time.now.beginning_of_month, Time.now.end_of_month)
      end
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end
  
  def payment_stats
    if current_user.has_role?(:admin)
      if params.has_key?(:select)
        @start_date = (params[:select][:year] + "-" + params[:select][:month] + "-" + 01.to_s).to_datetime.beginning_of_month
        @end_date = @start_date.end_of_month
        @transactions = Transaction.where("created_at BETWEEN ? AND ?",@start_date, @end_date)
      else
        @transactions = Transaction.where("created_at BETWEEN ? AND ?", Time.now.beginning_of_month, Time.now.end_of_month)
      end
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end

  def lead_stats
    if current_user.has_role?(:admin)
      @leads = Lead.all
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end
end