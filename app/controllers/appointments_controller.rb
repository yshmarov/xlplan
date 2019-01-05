class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :mark_planned, :mark_member_confirmed, :mark_client_confirmed, :mark_not_attended, :mark_member_cancelled, :mark_client_cancelled]

  def mark_attendance
    @q = Appointment.mark_attendance.ransack(params[:q])
    @appointments = @q.result.includes(:location, :client, :member, :service).paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
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

	def mark_member_confirmed
    authorize @appointment, :update?
    Appointment.public_activity_off
		@appointment.update_attribute(:status, 'member_confirmed')
    Appointment.public_activity_on
    @appointment.create_activity :change_status, parameters: {status: @appointment.status}
		redirect_to @appointment, notice: "Status updated to #{@appointment.status}"
	end

	def mark_client_confirmed
    authorize @appointment, :update?
    Appointment.public_activity_off
		@appointment.update_attribute(:status, 'client_confirmed')
    Appointment.public_activity_on
    @appointment.create_activity :change_status, parameters: {status: @appointment.status}
		redirect_to @appointment, notice: "Status updated to #{@appointment.status}"
	end

	def mark_not_attended
    authorize @appointment, :update?
    Appointment.public_activity_off
		@appointment.update_attribute(:status, 'not_attended')
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
    @appointments = @q.result.includes(:location, :client, :member).paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
  end

  def show
    authorize @appointment
    @activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "Appointment", trackable_id: @appointment).all
  end

  def new
    @appointment = Appointment.new
    authorize @appointment
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
      @appointment = Appointment.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(:tenant_id, :client_id, :member_id, :location_id, :starts_at, :ends_at, :status, :description, :status_color)
    end
end
