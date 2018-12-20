class ServiceCategoriesController < ApplicationController
  before_action :set_service_category, only: [:edit, :update, :destroy]

  def index
    @service_categories = ServiceCategory.all
  end

  def new
    @service_category = ServiceCategory.new
    authorize @service_category
  end

  def edit
    authorize @service_category
  end

  def create
    @service_category = ServiceCategory.new(service_category_params)
    authorize @service_category

    respond_to do |format|
      if @service_category.save
        format.html { redirect_to services_path, notice: 'Service category was successfully created.' }
        format.json { render :show, status: :created, location: @service_category }
      else
        format.html { render :new }
        format.json { render json: @service_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @service_category
    respond_to do |format|
      if @service_category.update(service_category_params)
        format.html { redirect_to services_path, notice: 'Service category was successfully updated.' }
        format.json { render :show, status: :ok, location: @service_category }
      else
        format.html { render :edit }
        format.json { render json: @service_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @service_category
    @service_category.destroy
    respond_to do |format|
      format.html { redirect_to services_path, notice: 'Service category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_category
      @service_category = ServiceCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_category_params
      params.require(:service_category).permit(:name)
    end
end
