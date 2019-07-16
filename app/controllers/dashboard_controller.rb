class DashboardController < ApplicationController
  def activity
    @activities = PublicActivity::Activity.paginate(:page => params[:page], :per_page => 50).order("created_at DESC").where(tenant_id: Tenant.current_tenant.id)
  end

  def start
  end

  def calendar
    @jobs = Job.includes(:event, :service, :event => :client)
    #if user.has_role(:admin) || user.has_role(:manager)
    #  @members = Member.active
    #else
    #  @members = current_user.member
    #end
    @members = Member.active
    #@events = Event.includes(:client, :jobs, :jobs => [:service, :member])
  end

  #def my_calendar
  #  @jobs = Job.where(member_id: current_user.member.id).includes(:event, :service, :member, :event => :client)
  #end

  def clients
    if current_user.has_role?(:admin)
      #next 5 bdays
      next_bdays = (Date.today + 0.day).yday
      @clients = Client.where("EXTRACT(DOY FROM date_of_birth) >= ?", next_bdays).order('EXTRACT (DOY FROM date_of_birth) ASC').first(5)
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end

  def members
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

  def events
    if current_user.has_role?(:admin)
      #average paycheck
      @average_confirmed_earnings = Job.joins(:event).where(events: {status: ['confirmed', 'no_show_refunded']}).average(:client_due_price).to_i/100
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end
  
  def payments
    if current_user.has_role?(:admin)
      #if params.has_key?(:select)
      #  if params[:select][:month] == 'all'
      #    @inbound_payments = query.where("YEAR(created_at) = ?", params[:select][:year])
      #  else
      #    @inbound_payments = query.where("MONTH(created_at) = ? AND YEAR(created_at) = ?", params[:select][:month], params[:select][:year])
      #  end
      #end

      #if params.has_key?(:select)
      #  start_date = (params[:select][:year]+"-" + params[:select][:month]+"-"+Date.today.day.to_s).to_datetime.beginning_of_day
      #  end_date = Date.today.end_of_day
      #  @inbound_payments = InboundPayment.where("created_at BETWEEN ? AND ?",start_date, end_date)
      #else
      #  @inbound_payments = InboundPayment.all
      #end
      @inbound_payments = InboundPayment.all
    else
      redirect_to root_path, alert: 'You are not authorized to view the page.'
    end
  end
end
