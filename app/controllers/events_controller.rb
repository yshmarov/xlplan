class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :mark_planned, :mark_confirmed, :mark_no_show, :mark_member_cancelled, :mark_client_cancelled]

  def close
    @q = Event.close.ransack(params[:q])
    @events = @q.result.includes(:location, :client, :jobs).paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
    render 'index'
  end

  def tomorrow
    @q = Event.tomorrow.ransack(params[:q])
    @events = @q.result.includes(:location, :client, :jobs).paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
    render 'index'
  end

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

  def index
    @q = Event.ransack(params[:q])
    @events = @q.result.includes(:location, :client, :jobs).paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
    #respond_to :json # add this line
    #respond_to do |format|
    #  format.html { render 'index' }
    #  format.json { render json: @events }
    #end
    #respond_to do |format|
    #  format.json
    #  format.html
    #end
  end

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
  end

  def new
    @event = Event.new
    authorize @event
    @event.jobs.build
  end

  def edit
    authorize @event
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
          jobs_attributes: [:id, :service_id, :member_id, :_destroy])
    end
end
