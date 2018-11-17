class SkillsController < ApplicationController
  before_action :set_skill, only: [:show, :destroy]

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params)

    respond_to do |format|
      if @skill.save
        format.html { redirect_to employee_path(@skill.employee), notice: 'Skill was successfully created.' }
        format.json { render :show, status: :created, location: @skill }
      else
        format.html { render :new }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
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
