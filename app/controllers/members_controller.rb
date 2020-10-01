class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy, :calendar]

  def index
    @ransack_members = Member.ransack(params[:members_search], search_key: :members_search)
    @members = @ransack_members.result.includes(:user, :skills)
  end

  def calendar_list
    @members = Member.active.order('created_at ASC')
    @locations = Location.all.includes(:workplaces)
    @jobs = Job.includes(:service, :member, :event => [:client, :workplace]).group_by { |job| [job.event, job.member] }
    render 'dashboard/calendar'
  end

  def calendar
    @members = Member.active.order('created_at ASC')
    @locations = Location.all.includes(:workplaces)
    @jobs = @member.jobs.includes(:service, :event => [:client, :workplace]).group_by { |job| [job.event, job.member] }
    render 'dashboard/calendar'
  end

  def show
    authorize @member
  end
  
  def edit
    authorize @member
  end

  def delete_avatar
    avatar = ActiveStorage::Attachment.find(params[:id])
    avatar.purge # or use purge_later
    #redirect_to @member
    redirect_to members_url, notice: 'Avatar deleted.'
    #redirect_back(fallback_location: members_path)
  end

  def new
    @member = Member.new
    authorize @member
    #7.times { @location.operating_hours.build}
  end

  def create
    @member = Member.new(member_params)
    authorize @member
    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @member
    #@member.avatar.attach(params[:avatar])
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
      redirect_to @member, alert: 'Member has associated jobs. Can not delete.'
    else
      redirect_to members_url, notice: 'Member was successfully destroyed.'
    end
  end

  private
    def set_member
      @member = Member.friendly.find(params[:id])
    end
  
    def member_params
      params.require(:member).permit(:first_name, :last_name, :phone_number, :email, :time_zone,
      :active, :location_id, :avatar, :online_booking,
      service_category_ids: [],
      operating_hours_attributes: [:id, :day_of_week, :closes, :opens, :valid_from, :valid_through, :_destroy])
    end
end