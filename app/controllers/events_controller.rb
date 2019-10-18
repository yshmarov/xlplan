class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, 
              :mark_planned, :mark_confirmed, :mark_no_show,
              :mark_member_cancelled, :mark_client_cancelled, :mark_no_show_refunded,
              :send_email_to_client, :send_email_to_members]

  def index
    @q = Event.ransack(params[:q])
    @events = @q.result.includes(:location, :client, :jobs).paginate(:page => params[:page], per_page: 15).order("created_at DESC")
    @ransack_path = events_path
  end

  def close
    @q = Event.close.ransack(params[:q])
    @events = @q.result.includes(:location, :client, :jobs).paginate(:page => params[:page], per_page: 15).order("created_at DESC")
    @ransack_path = close_events_path
    render 'index'
  end

  def today
    @q = Event.today.ransack(params[:q])
    @events = @q.result.includes(:location, :client, :jobs).paginate(:page => params[:page], per_page: 15).order("created_at DESC")
    @ransack_path = today_events_path
    render 'index'
  end

  def tomorrow
    @q = Event.tomorrow.ransack(params[:q])
    @events = @q.result.includes(:location, :client, :jobs).paginate(:page => params[:page], per_page: 15).order("created_at DESC")
    @ransack_path = tomorrow_events_path
    render 'index'
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
    @inbound_payments = @event.inbound_payments
    @inbound_payment = InboundPayment.new
    authorize @inbound_payment
    #@payable = @event
    #@inbound_payment.payable_id = @event.id
    #@inbound_payment.payable_type = "Event"
    #@payment.client_id = @event.client.id
    #@payment.amount = @event.client_price
    respond_to do |format|
        format.html
        format.pdf do
            render pdf: "Event No. #{@event.slug}",
            page_size: 'A6',
            template: "events/show.pdf.haml",
            layout: "pdf.haml",
            orientation: "Landscape",
            lowquality: true,
            zoom: 1,
            dpi: 75
        end
    end
  end

  def new
    @event = Event.new
    authorize @event
    @event.jobs.build
  end

  def edit
    authorize @event
  end

  def send_email_to_client
    authorize @event, :edit?
    if @event.client.email.present? && @event.client.event_created_notifications?
      Event.public_activity_off
      EventMailer.client_event_created(@event).deliver_now
      Event.public_activity_on
    end
		redirect_to @event, notice: "Email invitation sent to #{@event.client}"
  end
  
  def send_email_to_members
    authorize @event, :edit?
    if @event.users.distinct.pluck(:email).present?
      Event.public_activity_off
      EventMailer.member_event_created(@event).deliver_now
      Event.public_activity_on
    end
		redirect_to @event, notice: "Email invitation sent to #{@event.users.pluck(:email)}"
  end

  def create
    @event = Event.new(event_params)
    authorize @event
    respond_to do |format|
      Event.public_activity_off
      if @event.save
        Event.public_activity_on
        @event.create_activity :create, parameters: {status: @event.status}
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
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @event
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
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_event
      @event = Event.friendly.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:tenant_id, :client_id, :location_id, :starts_at, :duration, :ends_at,
          :client_price, :client_price_cents, :status, :status_color, :notes,
          :add_percent, :add_amount,
          files: [],
          jobs_attributes: [:id, :service_id, :member_id, :_destroy])
    end
end