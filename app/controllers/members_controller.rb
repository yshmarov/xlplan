class MembersController < ApplicationController

  before_action :set_member, only: [:show, :edit, :update, :destroy]
  # uncomment to ensure common layout for forms
  # layout  "sign", :only => [:new, :edit, :create]

  def index
    @ransack_members = Member.search(params[:members_search], search_key: :members_search)
    @members = @ransack_members.result.includes(:user).paginate(:page => params[:page], :per_page => 15)
  end

  def show
    authorize @member
    @jobs = @member.jobs
    @appointments = @member.appointments
    @skills = @member.skills
  end
  
  def edit
    authorize @member
  end

  def new()
    @member = Member.new()
    @user   = User.new()
    authorize @member
    authorize @user
  end

  def create()
    @user   = User.new( user_params )
    #authorize @member
    authorize @user

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
    #authorize @user
    if @member.update(member_params)
      redirect_to @member, notice: 'Member was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @member
    #authorize @user
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
  
    def member_params()
      params.require(:member).permit(:first_name, :last_name, :phone_number, :email, :date_of_birth, :gender, :address,
      :status, :balance, :location_id, service_category_ids: [])
    end
  
    def user_params()
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
