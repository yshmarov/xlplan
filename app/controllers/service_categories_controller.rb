class ServiceCategoriesController < ApplicationController
  def create
    @service_category = ServiceCategory.new(service_category_params)
    if @service_category.save
      render json: @service_category
    else
      render json: {errors: @service_category.errors.full_messages}
    end
  end

  private

    def service_category_params
      params.require(:service_category).permit(:name)
    end
end
