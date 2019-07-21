class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  #include StatusHelper

  def index
    @locations = Location.all
  end

  def show
    authorize @location
    @events = @location.events
  end

  def new
    @location = Location.new
    authorize @location
  end

  def edit
    authorize @location
  end

  def create
    @location = Location.new(location_params)
    authorize @location

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @location
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @location
    @location.destroy
    if @location.errors.present?
      redirect_to locations_url, alert: 'Location has associated records. Can not delete.'
    else
      redirect_to locations_url, notice: 'Location was successfully destroyed.'
    end
  end

  private
    def set_location
      @location = Location.friendly.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:name, :phone_number, :email, :status, :address)
      #params.require(:location).permit(:name, :phone_number, :email, :status, address: [:country, :city, :street, :zip])
    end
end
