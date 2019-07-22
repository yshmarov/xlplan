class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  def index
    @ransack_members = Member.search(params[:members_search], search_key: :members_search)
    @members = @ransack_members.result.includes(:user, :skills).paginate(:page => params[:page], :per_page => 15)
  end

  def show
    authorize @member
    @jobs = @member.jobs.includes(:event)
    #@events = @member.events.planned.order("starts_at DESC")
    #@member.includes(:user)
    #@expendable = @member
    #@expences = @expendable.expences
    @expence = Expence.new
  end
  
  def edit
    authorize @member
  end

  def new
    @member = Member.new
    authorize @member
  end

  def create
    @member   = Member.new(member_params)
    #authorize @member
    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @member
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @member
    @member.destroy
    if @member.errors.present?
      redirect_to members_url, alert: 'Member has associated jobs. Can not delete.'
    else
      redirect_to members_url, notice: 'Member was successfully destroyed.'
    end
  end

  private
    def set_member
      @member = Member.friendly.find(params[:id])
    end
  
    def member_params
      params.require(:member).permit(:first_name, :last_name, :phone_number, :email, :date_of_birth, :gender, :address, :time_zone,
      :status, :location_id, service_category_ids: [], address: [:country, :city, :street, :zip])
    end
end