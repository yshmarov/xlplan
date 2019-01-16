class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :mark_planned, :mark_confirmed, :mark_client_not_attended, :mark_member_cancelled, :mark_client_cancelled]

  def checkout
    @q = Appointment.checkout.ransack(params[:q])
    @appointments = @q.result.includes(:location, :client, :jobs).paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
    render 'index'
  end

	def mark_planned
    authorize @appointment, :update?
    Appointment.public_activity_off
		@appointment.update_attribute(:status, 'planned')
    Appointment.public_activity_on
    @appointment.create_activity :change_status, parameters: {status: @appointment.status}
		redirect_to @appointment, notice: "Status updated to #{@appointment.status}"
	end

	def mark_confirmed
    authorize @appointment, :update?
    Appointment.public_activity_off
		@appointment.update_attribute(:status, 'confirmed')
    Appointment.public_activity_on
    @appointment.create_activity :change_status, parameters: {status: @appointment.status}
		redirect_to @appointment, notice: "Status updated to #{@appointment.status}"
	end

	def mark_client_not_attended
    authorize @appointment, :update?
    Appointment.public_activity_off
		@appointment.update_attribute(:status, 'client_not_attended')
    Appointment.public_activity_on
    @appointment.create_activity :change_status, parameters: {status: @appointment.status}
		redirect_to @appointment, notice: "Status updated to #{@appointment.status}"
	end

	def mark_client_cancelled
    authorize @appointment, :update?
    Appointment.public_activity_off
		@appointment.update_attribute(:status, 'client_cancelled')
    Appointment.public_activity_on
    @appointment.create_activity :change_status, parameters: {status: @appointment.status}
		redirect_to @appointment, notice: "Status updated to #{@appointment.status}"
	end

	def mark_member_cancelled
    authorize @appointment, :update?
    Appointment.public_activity_off
		@appointment.update_attribute(:status, 'member_cancelled')
    Appointment.public_activity_on
    @appointment.create_activity :change_status, parameters: {status: @appointment.status}
		redirect_to @appointment, notice: "Status updated to #{@appointment.status}"
	end

  def index
    @q = Appointment.ransack(params[:q])
    @appointments = @q.result.includes(:location, :client, :jobs).paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
  end

  def show
    authorize @appointment
    @jobs = @appointment.jobs
    @activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "Appointment", trackable_id: @appointment).all
  end

  def new
    @appointment = Appointment.new
    authorize @appointment
    @appointment.jobs.build
  end

  def edit
    authorize @appointment
  end

  def create
    @appointment = Appointment.new(appointment_params)
    authorize @appointment

    respond_to do |format|
      Appointment.public_activity_off
      if @appointment.save
        Appointment.public_activity_on
        @appointment.create_activity :create, parameters: {status: @appointment.status}
        format.html { redirect_to @appointment, notice: 'Appointment was successfully created.' }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @appointment
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to @appointment, notice: 'Appointment was successfully updated.' }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @appointment
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to appointments_url, notice: 'Appointment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_appointment
      @appointment = Appointment.friendly.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(:tenant_id, :client_id, :location_id,
          :starts_at, :duration, :ends_at,
          :client_price, :client_price_cents, 
          :status, :status_color, :notes,
          jobs_attributes: [:id, :service_id, :member_id, :_destroy])
    end
end
