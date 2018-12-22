class ServiceCategoriesController < ApplicationController
  before_action :set_service_category, only: [:edit, :update, :destroy]

  def index
    @service_categories = ServiceCategory.all.order('updated_at DESC')
  end

  def edit
    authorize @service_category
  end

  def create
    @service_category = ServiceCategory.new(service_category_params)
    if @service_category.save
      render json: @service_category
    else
      render json: {errors: @service_category.errors.full_messages}
    end
  end

  def update
    authorize @service_category
    if @service_category.update(service_category_params)
      redirect_to service_categories_url, notice: 'Service category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @service_category
    @service_category.destroy
    redirect_to service_categories_url, notice: 'Service category was successfully destroyed.'
  end

  private
    def set_service_category
      @service_category = ServiceCategory.find(params[:id])
    end

    def service_category_params
      params.require(:service_category).permit(:name)
    end
end
