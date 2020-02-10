class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy, :calendar]

  def index
    @ransack_members = Member.ransack(params[:members_search], search_key: :members_search)
    @members = @ransack_members.result.includes(:user, :skills)
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
    @user   = User.new
    #authorize @member
    #authorize @user
    #7.times { @location.operating_hours.build}
  end

  def create
    @user   = User.new( user_params )
    #authorize @member
    #authorize @user

    # ok to create user, member
    if @user.save_and_invite_member() && @user.create_member( member_params )
      flash[:notice] = "New member added and invitation email sent to #{@user.email}."
      redirect_to @user.member
    else
      #flash[:error] = "errors occurred!"
      @member = Member.new( member_params ) # only used if need to revisit form
      render :new
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
      params.require(:member).permit(:first_name, :last_name, :phone_number, :email, :date_of_birth, :gender, :address, :time_zone,
      :active, :location_id, :avatar, :online_booking,
      :country, :city, :zip, :address,
      service_category_ids: [],
      operating_hours_attributes: [:id, :day_of_week, :closes, :opens, :valid_from, :valid_through, :_destroy])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end