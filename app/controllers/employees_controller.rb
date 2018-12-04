class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  def index
    #@employees = Employee.paginate(:page => params[:page], :per_page => 10)

    @ransack_employees = Employee.search(params[:employees_search], search_key: :employees_search)
    @employees = @ransack_employees.result.includes(:location).paginate(:page => params[:page], :per_page => 15)
  end

	#def invite_user
  #  @user = User.invite!(email: @employee.email, employee_id: @employee.id)
	#	redirect_to users_url
	#end

  def show
    authorize @employee
    @jobs = @employee.jobs
    @skills = @employee.skills
    @employee_total_earnings = @jobs.map(&:employee_due_price_cents).sum
  end

  def new
    @employee = Employee.new
    authorize @employee
  end

  def edit
    authorize @employee
  end

  def create
    @employee = Employee.new(employee_params)
    authorize @employee

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
    authorize @employee
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
    authorize @employee
    @employee.destroy
    if @employee.errors.present?
      redirect_to employees_url, alert: 'Employee has associated jobs. Can not delete.'
    else
      redirect_to employees_url, notice: 'Employee was successfully destroyed.'
    end
  end

  private
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:first_name, :middle_name, :last_name, :date_of_birth,
      :gender, :email, :phone_number, :address, :description, :status, :balance,
      :location_id, :employment_date, :termination_date, :balance, :status)

    end
end
