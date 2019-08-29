class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  def index
    @q = Service.ransack(params[:q])
    @services = @q.result.includes(:service_category).paginate(:page => params[:page], :per_page => 20).order("updated_at DESC")
  end

  def show
    authorize @service
    @activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "Service", trackable_id: @service).all
  end

  def new
    @service = Service.new
    authorize @service
  end

  def edit
    authorize @service
  end

  def create
    @service = Service.new(service_params)
    authorize @service

    respond_to do |format|
      if @service.save
        format.html { redirect_to services_url, notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @service
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to services_url, notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @service
    @service.destroy
    if @service.errors.present?
      redirect_to services_url, alert: 'Service has associated jobs. Can not delete.'
    else
      redirect_to services_url, notice: 'Service was successfully destroyed.'
    end
  end

  private
    def set_service
      @service = Service.friendly.find(params[:id])
    end

    def service_params
      params.require(:service).permit(:service_category_id, :name, :description, :duration, 
          :client_price, :member_price, :client_price_cents, :member_price_cents, :member_percent, 
          :status)
    end
end
