class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :mark_planned, :mark_confirmed, :mark_confirmed_by_client, :mark_not_attended, :mark_rejected_by_us, :mark_cancelled_by_client]

  def index
    #@jobs = Job.paginate(:page => params[:page], :per_page => 10)
    @q = Job.ransack(params[:q])
    @jobs = @q.result.includes(:service).paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
  end

  def show
    authorize @job
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
      #@job = Job.find(params[:id])
      @job = Job.friendly.find(params[:id])
    end

    def job_params
      params.require(:job).permit(:service_id, :member_id, :event_id,
        :service_duration, :service_member_percent, 
        :client_price, :member_price, :member_due_price, :client_due_price)
    end
end
