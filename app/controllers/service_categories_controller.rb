class ServiceCategoriesController < ApplicationController
  before_action :set_service_category, only: [:show, :edit, :update, :destroy]

  def index
    @service_categories = ServiceCategory.all.order('updated_at DESC')
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

    #############only JSON for service/new#############
    #if @service_category.save
    #  render json: @service_category
    #else
    #  render json: {errors: @service_category.errors.full_messages}
    #end

    respond_to do |format|
      if @service_category.save
        format.html { redirect_to service_categories_path, notice: 'Service category was successfully created.' }
        format.json { render json: @service_category }
      else
        format.html { render :new }
        format.json { render json: {errors: @service_category.errors.full_messages} }
      end
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
    if @service_category.errors.present?
      redirect_to service_categories_url, alert: 'Service Category has associated services or skills. Can not delete.'
    else
      redirect_to service_categories_url, notice: 'Service Category was successfully destroyed.'
    end
  end

  private
    def set_service_category
      @service_category = ServiceCategory.friendly.find(params[:id])
    end

    def service_category_params
      params.require(:service_category).permit(:name)
    end
end
