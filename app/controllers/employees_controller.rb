class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  def index
    #@employees = Employee.paginate(:page => params[:page], :per_page => 10)

    @ransack_employees = Employee.search(params[:employees_search], search_key: :employees_search)
    @employees = @ransack_employees.result.includes(:person).paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @person = @employee.person
    @jobs = @employee.jobs
    @employee_categories = @employee.employee_categories
    @employee_total_earnings = @jobs.map(&:employee_due_price_cents).sum
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:person_id, :location_id, :specialization, :employment_date, :termination_date, :balance, :status)
    end
end
