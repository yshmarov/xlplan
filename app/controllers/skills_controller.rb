class SkillsController < ApplicationController
  before_action :set_skill, only: [:destroy]

  def new
    @member = Member.find(params[:member_id])
    @skill = Skill.new
    #@skill.member_id = params[:member_id]

    #@skill = Skill.new(:post=>@post)
    #@skill = @member.skills.build

  end

  def create
    @member = Member.find(params[:member_id])
    #@skill = @member.skills.create(params[:skill])
    @skill = Skill.new(skill_params)

    respond_to do |format|
      if @skill.save
        format.html { redirect_to member_path(@skill.member), notice: 'Skill was successfully created.' }
        #format.html { redirect_to [@skill.member, @skill], notice: 'Skill was successfully created.' }

        format.json { render :show, status: :created, location: @skill }
      else
        format.html { render :new }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
        #format.json { render json: new_member_skill_path[@member, skill].errors, status: :unprocessable_entity }

      end
    end
  end

  def destroy
    @member = Member.find(params[:member_id])
    #@skill = @member.skills.find(params[:id])
    @skill.destroy
    respond_to do |format|
      format.html { redirect_to member_path(@skill.member), notice: 'Skill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_skill
      @skill = Skill.find(params[:id])
    end

    def skill_params
      params.require(:skill).permit(:member_id, :service_category_id)
    end
end
