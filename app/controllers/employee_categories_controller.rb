class EmployeeCategoriesController < ApplicationController
  before_action :set_employee_category, only: [:show, :edit, :update, :destroy]

  # GET /employee_categories
  # GET /employee_categories.json
  def index
    @employee_categories = EmployeeCategory.all
  end

  # GET /employee_categories/1
  # GET /employee_categories/1.json
  def show
  end

  # GET /employee_categories/new
  def new
    @employee_category = EmployeeCategory.new
  end

  # GET /employee_categories/1/edit
  def edit
  end

  # POST /employee_categories
  # POST /employee_categories.json
  def create
    @employee_category = EmployeeCategory.new(employee_category_params)

    respond_to do |format|
      if @employee_category.save
        format.html { redirect_to @employee_category, notice: 'Employee category was successfully created.' }
        format.json { render :show, status: :created, location: @employee_category }
      else
        format.html { render :new }
        format.json { render json: @employee_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employee_categories/1
  # PATCH/PUT /employee_categories/1.json
  def update
    respond_to do |format|
      if @employee_category.update(employee_category_params)
        format.html { redirect_to @employee_category, notice: 'Employee category was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee_category }
      else
        format.html { render :edit }
        format.json { render json: @employee_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_categories/1
  # DELETE /employee_categories/1.json
  def destroy
    @employee_category.destroy
    respond_to do |format|
      format.html { redirect_to employee_categories_url, notice: 'Employee category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_category
      @employee_category = EmployeeCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_category_params
      params.require(:employee_category).permit(:employee_id, :category_id)
    end
end
