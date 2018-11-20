class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :mark_planned, :mark_confirmed, :mark_cancelled]

  def planned_in_past
    @jobs = Job.planned_in_past
  end

	def mark_planned
		@job.update_attribute(:status, 'planned')
		redirect_to @job, notice: "Status updated to #{@job.status}"
	end

	def mark_confirmed
		@job.update_attribute(:status, 'confirmed')
		redirect_to @job, notice: "Status updated to #{@job.status}"
	end

	def mark_cancelled
		@job.update_attribute(:status, 'cancelled_by_client')
		redirect_to @job, notice: "Status updated to #{@job.status}"
	end

  def index
    #@jobs = Job.paginate(:page => params[:page], :per_page => 10)
    @q = Job.ransack(params[:q])
    @jobs = @q.result.includes(:location, :client, :employee, :service).paginate(:page => params[:page], :per_page => 10).order("created_at DESC")
  end

  def show
    #@commentable = @job
    #@comments = @commentable.comments
    #@comment = Comment.new
  end

  def new
    @job = Job.new
  end

  def edit
  end

  def create
    @job = Job.new(job_params)
    @job.created_by = current_user.employee.id

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
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
      params.require(:job).permit(:client_id, :starts_at, :ends_at, :status, :service_id, :location_id, :employee_id, :service_name,
      :service_description, :service_duration, :client_price, :employee_price, :employee_due_price, :client_due_price, :description)
    end
end
