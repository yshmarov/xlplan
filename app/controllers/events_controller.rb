class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, 
              :mark_planned, :mark_confirmed, :mark_no_show,
              :mark_member_cancelled, :mark_client_cancelled, :mark_no_show_refunded,
              :send_email_to_client, :send_email_to_members, :create_duplicate]
  include Pagy::Backend

  def index
    @q = Event.ransack(params[:q])
    @pagy, @events = pagy(@q.result.includes(:workplace, :client, :jobs).order("starts_at DESC"))
    @ransack_path = events_path
  end

  def close
    @q = Event.close.ransack(params[:q])
    @pagy, @events = pagy(@q.result.includes(:workplace, :client, :jobs).order("starts_at DESC"))
    @ransack_path = close_events_path
    render 'index'
  end

  def today
    @q = Event.today.ransack(params[:q])
    @pagy, @events = pagy(@q.result.includes(:workplace, :client, :jobs).order("starts_at DESC"))
    @ransack_path = today_events_path
    render 'index'
  end

  def tomorrow
    @q = Event.tomorrow.ransack(params[:q])
    @pagy, @events = pagy(@q.result.includes(:workplace, :client, :jobs).order("starts_at DESC"))
    @ransack_path = tomorrow_events_path
    render 'index'
  end

  ### BUTTONS ###
  def create_duplicate
    authorize @event, :update?
    Event.public_activity_off
    new_event = Event.create(workplace: @event.workplace, client: @event.client, jobs: @event.jobs, status: 'planned', starts_at: @event.starts_at)
    Event.public_activity_on
    new_event.create_activity :create_duplicate, parameters: {original: @event.slug}
		redirect_to new_event, notice: "Duplicate created from #{@event.slug}"
  end
  ##### BUTTONS TO CHANGE STATUS #####
	def mark_planned
    authorize @event, :update?
    Event.public_activity_off
		@event.update_attribute(:status, 'planned')
    Event.public_activity_on
    @event.create_activity :change_status, parameters: {status: @event.status}
		redirect_to @event, notice: "Status updated to #{@event.status}"
	end

	def mark_confirmed
    authorize @event, :update?
    Event.public_activity_off
		@event.update_attribute(:status, 'confirmed')
    Event.public_activity_on
    @event.create_activity :change_status, parameters: {status: @event.status}
		redirect_to @event, notice: "Status updated to #{@event.status}"
	end

	def mark_no_show
    authorize @event, :update?
    Event.public_activity_off
		@event.update_attribute(:status, 'no_show')
    Event.public_activity_on
    @event.create_activity :change_status, parameters: {status: @event.status}
		redirect_to @event, notice: "Status updated to #{@event.status}"
	end

	def mark_client_cancelled
    authorize @event, :update?
    Event.public_activity_off
		@event.update_attribute(:status, 'client_cancelled')
    Event.public_activity_on
    @event.create_activity :change_status, parameters: {status: @event.status}
		redirect_to @event, notice: "Status updated to #{@event.status}"
	end

	def mark_member_cancelled
    authorize @event, :update?
    Event.public_activity_off
		@event.update_attribute(:status, 'member_cancelled')
    Event.public_activity_on
    @event.create_activity :change_status, parameters: {status: @event.status}
		redirect_to @event, notice: "Status updated to #{@event.status}"
	end

	def mark_no_show_refunded
    authorize @event, :update?
    Event.public_activity_off
		@event.update_attribute(:status, 'no_show_refunded')
    Event.public_activity_on
    @event.create_activity :change_status, parameters: {status: @event.status}
		redirect_to @event, notice: "Status updated to #{@event.status}"
	end
  ##### END BUTTONS TO CHANGE STATUS #####

  def show
    authorize @event
    @jobs = @event.jobs
    @activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "Event", trackable_id: @event).all
    respond_to do |format|
      format.html
      format.pdf do
          render pdf: "Event No. #{@event.slug}",
          page_size: 'A6',
          template: "events/show.pdf.haml",
          layout: "pdf.html.haml",
          orientation: "Landscape",
          lowquality: true,
          zoom: 1,
          dpi: 75
      end
    end
  end

  def new
    @event = Event.new
    @clients = Client.all
    #@services = Service.includes(:service_category)
    @workplaces = Workplace.order(:location_id)
    @members = Member.all
    @service_categories = ServiceCategory.all
    authorize @event
    @event.jobs.build
  end

  def edit
    authorize @event
    @clients = Client.all
    #@services = Service.includes(:service_category)
    @workplaces = Workplace.order(:location_id)
    @members = Member.all
    @service_categories = ServiceCategory.all
  end

  def send_email_to_client
    authorize @event, :edit?
    if @event.client.email.present? && @event.client.event_created_notifications?
      Event.public_activity_off
      EventMailer.client_event_created(@event).deliver_later
      Event.public_activity_on
    end
		redirect_to @event, notice: "Email invitation sent to #{@event.client.email}"
  end
  
  def send_email_to_members
    authorize @event, :edit?
    if @event.users.distinct.pluck(:email).present?
      Event.public_activity_off
      EventMailer.member_event_created(@event).deliver_later
      Event.public_activity_on
    end
		redirect_to @event, notice: "Email invitation sent to #{@event.users.pluck(:email)}"
  end

  def create
    @event = Event.new(event_params)
    authorize @event
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: t('.success') }
        format.json { render :show, status: :created, location: @event }

        #if @event.client.email.present? && @event.client.event_created_notifications?
        #  EventMailer.client_event_created(@event).deliver_now
        #end

        #if @event.client.email.present?
        #  EventMailer.member_event_created(@event).deliver_now
        #end
        
        #current working version
        #EventMailer.event_created.deliver_now
        #EventMailer.with(event: @event, member: @user.member).welcome_email(event).deliver_now

        #EventMailer.new_signup_booking_admin(@user, @booking).deliver_later

        #EventMailer.with(event: @event, member: @user.member).welcome_email.deliver_later
        #EventMailer.with(user: @user).welcome_email.deliver_later
      else
        @clients = Client.all
        #@services = Service.includes(:service_category)
        @workplaces = Workplace.order(:location_id)
        @members = Member.all
        @service_categories = ServiceCategory.all
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @event
    @clients = Client.all
    #@services = Service.includes(:service_category)
    @workplaces = Workplace.order(:location_id)
    @service_categories = ServiceCategory.all
    @members = Member.all
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: t('.success') }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @event
    @event.destroy
    respond_to do |format|
      format.html { redirect_to @event.client, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_event
      @event = Event.friendly.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:client_id, :workplace_id, :starts_at, :notes,
          files: [],
          jobs_attributes: [:id, :service_id, :member_id, :_destroy,
            :add_amount, :add_amount_cents, :production_cost, :production_cost_cents])
    end
end