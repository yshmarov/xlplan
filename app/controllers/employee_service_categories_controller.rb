class EmployeeServiceCategoriesController < ApplicationController
  before_action :set_employee_service_category, only: [:show, :edit, :update, :destroy]

  # GET /employee_service_categories
  # GET /employee_service_categories.json
  def index
    @employee_service_categories = EmployeeServiceCategory.all
  end

  # GET /employee_service_categories/1
  # GET /employee_service_categories/1.json
  def show
  end

  # GET /employee_service_categories/new
  def new
    @employee_service_category = EmployeeServiceCategory.new
  end

  # GET /employee_service_categories/1/edit
  def edit
  end

  # POST /employee_service_categories
  # POST /employee_service_categories.json
  def create
    @employee_service_category = EmployeeServiceCategory.new(employee_service_category_params)

    respond_to do |format|
      if @employee_service_category.save
        format.html { redirect_to @employee_service_category, notice: 'Employee service category was successfully created.' }
        format.json { render :show, status: :created, location: @employee_service_category }
      else
        format.html { render :new }
        format.json { render json: @employee_service_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employee_service_categories/1
  # PATCH/PUT /employee_service_categories/1.json
  def update
    respond_to do |format|
      if @employee_service_category.update(employee_service_category_params)
        format.html { redirect_to @employee_service_category, notice: 'Employee service category was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee_service_category }
      else
        format.html { render :edit }
        format.json { render json: @employee_service_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_service_categories/1
  # DELETE /employee_service_categories/1.json
  def destroy
    @employee_service_category.destroy
    respond_to do |format|
      format.html { redirect_to employee_service_categories_url, notice: 'Employee service category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_service_category
      @employee_service_category = EmployeeServiceCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_service_category_params
      params.require(:employee_service_category).permit(:employee_id, :service_category_id)
    end
end
