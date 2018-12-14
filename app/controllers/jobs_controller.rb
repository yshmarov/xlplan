class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :mark_planned, :mark_confirmed, :mark_confirmed_by_client, :mark_not_attended, :mark_rejected_by_us, :mark_cancelled_by_client]

  def mark_attendance
    @jobs = Job.mark_attendance
  end

	def mark_planned
    authorize @job, :update?
    Job.public_activity_off
		@job.update_attribute(:status, 'planned')
    Job.public_activity_on
    @job.create_activity :change_status, parameters: {status: @job.status}
		redirect_to @job, notice: "Status updated to #{@job.status}"
	end

	def mark_confirmed
    authorize @job, :update?
    Job.public_activity_off
		@job.update_attribute(:status, 'confirmed')
    Job.public_activity_on
    @job.create_activity :change_status, parameters: {status: @job.status}
		redirect_to @job, notice: "Status updated to #{@job.status}"
	end

	def mark_confirmed_by_client
    authorize @job, :update?
    Job.public_activity_off
		@job.update_attribute(:status, 'confirmed_by_client')
    Job.public_activity_on
    @job.create_activity :change_status, parameters: {status: @job.status}
		redirect_to @job, notice: "Status updated to #{@job.status}"
	end

	def mark_not_attended
    authorize @job, :update?
    Job.public_activity_off
		@job.update_attribute(:status, 'not_attended')
    Job.public_activity_on
    @job.create_activity :change_status, parameters: {status: @job.status}
		redirect_to @job, notice: "Status updated to #{@job.status}"
	end

	def mark_cancelled_by_client
    authorize @job, :update?
    Job.public_activity_off
		@job.update_attribute(:status, 'cancelled_by_client')
    Job.public_activity_on
    @job.create_activity :change_status, parameters: {status: @job.status}
		redirect_to @job, notice: "Status updated to #{@job.status}"
	end

	def mark_rejected_by_us
    authorize @job, :update?
    Job.public_activity_off
		@job.update_attribute(:status, 'rejected_by_us')
    Job.public_activity_on
    @job.create_activity :change_status, parameters: {status: @job.status}
		redirect_to @job, notice: "Status updated to #{@job.status}"
	end

  def index
    #@jobs = Job.paginate(:page => params[:page], :per_page => 10)
    @q = Job.ransack(params[:q])
    @jobs = @q.result.includes(:location, :client, :member, :service).paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
  end

  def show
    authorize @job
    #@commentable = @job
    #@comments = @commentable.comments
    #@comment = Comment.new
  end

  def new
    @job = Job.new
    authorize @job
  end

  def edit
    authorize @job
  end

  def create
    @job = Job.new(job_params)
    authorize @job
    @job.created_by = current_user.member.id


    respond_to do |format|
      Job.public_activity_off

      if @job.save
        Job.public_activity_on

        @job.create_activity :create, parameters: {status: @job.status}

        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @job
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @job
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_job
      @job = Job.find(params[:id])
    end

    def job_params
      params.require(:job).permit(:client_id, :starts_at, :ends_at, :status, :service_id, :location_id, :member_id, :service_name,
      :service_description, :service_duration, :service_member_percent, :client_price, :member_price, :member_due_price, :client_due_price, :description)
    end
end
