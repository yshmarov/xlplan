class DashboardController < ApplicationController
  def activity
    @activities = PublicActivity::Activity.paginate(:page => params[:page], per_page: 50).order("created_at DESC").where(tenant_id: Tenant.current_tenant.id)
  end

  def dashboard
    @events_today = Event.where("created_at >= ?", Time.zone.now.beginning_of_day).count
    @clients_today = Client.where("created_at >= ?", Time.zone.now.beginning_of_day).count
    @payments_today = InboundPayment.where("created_at >= ?", Time.zone.now.beginning_of_day).count
  end

  def start
  end

  def calendar
    if current_user.has_role?(:admin) || current_user.has_role?(:manager)
      #@members = Member.active.includes(:location).order('created_at ASC')
      @members = Member.active.order('created_at ASC')
      @jobs = Job.includes(:event, :service, :event => :client)
    else
      #@members = current_user.member #not activerecord
      #@jobs = @members.jobs.includes(:event, :service, :event => :client) #not activerecord
      @members = Member.where(user_id: current_user.id)
      @jobs = Job.joins(:member).where(members: {user_id: current_user.id}).includes(:event, :service, :event => :client)
    end
    
    #@jobs = Job.includes(:event, :service, :member, :event => :client)
    #@events = Event.includes(:client, :jobs, :jobs => [:service, :member])
  end

  #def my_calendar
  #  @jobs = Job.where(member_id: current_user.member.id).includes(:event, :service, :member, :event => :client)
  #end

  def client_stats
    if current_user.has_role?(:admin)
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end

  def member_stats
    if current_user.has_role?(:admin)
      #performance vs others
      @members = Member.all

      #company confirmed earning
      @confirmed_hours_worked = (Job.joins(:event).where(events: {status: ['confirmed', 'no_show_refunded']}).map(&:service_duration).sum)/60.to_d
      @confirmed_job_q = Job.joins(:event).where(events: {status: ['confirmed', 'no_show_refunded']}).count
      @total_confirmed_earnings = Job.joins(:event).where(events: {status: ['confirmed', 'no_show_refunded']}).map(&:client_due_price_cents).sum
      @total_confirmed_expences = Job.joins(:event).where(events: {status: ['confirmed', 'no_show_refunded']}).map(&:member_due_price_cents).sum
      @total_confirmed_net_income = @total_confirmed_earnings - @total_confirmed_expences
  
      #company planned earnings
      @planned_hours_worked = (Job.joins(:event).where(events: {status: 'planned'}).map(&:service_duration).sum)/60.to_d
      @planned_job_q = Job.joins(:event).where(events: {status: 'planned'}).count
      @total_planned_earnings = Job.joins(:event).where(events: {status: 'planned'}).map(&:client_price_cents).sum
      @total_planned_expences = Job.joins(:event).where(events: {status: 'planned'}).map(&:member_price_cents).sum
      @total_planned_net_income = @total_planned_earnings - @total_planned_expences
  
      #company loss stats
      @lost_hours_worked = (Job.joins(:event).where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).map(&:service_duration).sum)/60.to_d
      @lost_job_q = Job.joins(:event).where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).count
      @total_lost_earnings = Job.joins(:event).where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).map(&:client_price_cents).sum
      @total_lost_expences = Job.joins(:event).where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).map(&:member_price_cents).sum
      @total_net_losses = @total_lost_earnings - @total_lost_expences
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end

  def member_salary
    if current_user.has_role?(:admin)
      @members = Member.all
      if params.has_key?(:select)
        @start_date = (params[:select][:year] + "-" + params[:select][:month] + "-" + 01.to_s).to_datetime.beginning_of_month
        @end_date = @start_date.end_of_month
        @member = params[:member]
        #WORKS but must be event starts_at, not job created_at
        #@jobs = Job.where("created_at BETWEEN ? AND ?",@start_date, @end_date).where(member_id: @member)
        #WORKS CORRECTLY!
        @jobs = Job.joins(:event, :service, :service => :service_category, :event => :client).where(events: {:starts_at => @start_date..@end_date}).where(member_id: @member)
        #did not try this
        #@jobs = Job.where('starts_at BETWEEN ? AND ?', @selected_date.beginning_of_day, @selected_date.end_of_day)
        
        @planned_salary = @jobs.joins(:event).where(events: {status: 'planned'}).map(&:member_price).sum/100
        @confirmed_salary = @jobs.joins(:event).where(events: {status: ['confirmed', 'no_show_refunded']}).map(&:member_price).sum/100
        @cancelled_salary = @jobs.joins(:event).where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).map(&:member_price).sum/100
      else
        #WORKS but must be event starts_at, not job created_at
        #@jobs = Job.where("created_at BETWEEN ? AND ?", Time.now.beginning_of_month, Time.now.end_of_month).where(member_id: 0)
        #WORKS CORRECTLY!
        @jobs = Job.joins(:event, :service, :service => :service_category, :event => :client).where(events: {:starts_at => Time.now.beginning_of_month..Time.now.end_of_month}).where(member_id: 0)
      end
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end

  def expence_stats
    if current_user.has_role?(:admin)
      if params.has_key?(:select)
        @start_date = (params[:select][:year] + "-" + params[:select][:month] + "-" + 01.to_s).to_datetime.beginning_of_month
        @end_date = @start_date.end_of_month
        @expences = Expence.where("created_at BETWEEN ? AND ?",@start_date, @end_date)
      else
        @expences = Expence.where("created_at BETWEEN ? AND ?", Time.now.beginning_of_month, Time.now.end_of_month)
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
        @inbound_payments = InboundPayment.where("created_at BETWEEN ? AND ?",@start_date, @end_date)
      else
        @inbound_payments = InboundPayment.where("created_at BETWEEN ? AND ?", Time.now.beginning_of_month, Time.now.end_of_month)
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