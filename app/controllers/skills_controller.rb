class SkillsController < ApplicationController
  before_action :set_skill, only: [:destroy]

  def new
    @employee = Employee.find(params[:employee_id])
    @skill = Skill.new
    #@skill = Skill.new(:post=>@post)
    #@skill = @employee.skills.build

  end

  def create
    @employee = Employee.find(params[:employee_id])
    #@skill = @employee.skills.create(params[:skill])
    @skill = Skill.new(skill_params)

    respond_to do |format|
      if @skill.save
        format.html { redirect_to employee_path(@skill.employee), notice: 'Skill was successfully created.' }
        #format.html { redirect_to [@skill.employee, @skill], notice: 'Skill was successfully created.' }

        format.json { render :show, status: :created, location: @skill }
      else
        format.html { render :new }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
        #format.json { render json: new_employee_skill_path[@employee, skill].errors, status: :unprocessable_entity }

      end
    end
  end

  def destroy
    @employee = Employee.find(params[:employee_id])
    #@skill = @employee.skills.find(params[:id])
    @skill.destroy
    respond_to do |format|
      format.html { redirect_to employee_path(@skill.employee), notice: 'Skill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_skill
      @skill = Skill.find(params[:id])
    end

    def skill_params
      params.require(:skill).permit(:employee_id, :service_category_id)
    end
end
