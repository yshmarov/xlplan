class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy, :invite_user]

  def index
    @ransack_members = Member.ransack(params[:members_search], search_key: :members_search)
    @members = @ransack_members.result.includes(:user, :skills).paginate(:page => params[:page], :per_page => 15)
  end

  def show
    authorize @member
    #@jobs = @member.jobs.includes(:event)
    @jobs = @member.jobs.includes(:event, :service, :event => :client)
    #@events = @member.events.planned.order("starts_at DESC")
    #@member.includes(:user)
    #for polymorphic show
    @expendable = @member
    @expences = @expendable.expences
    #for polymorphic new
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
    authorize @member
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
  
  def invite_user
    @user = User.new(user_params)
    #@user.email = @member.email
    #authorize @user
    #authorize @member
    # ok to create user, member
    if @user.save_and_invite_member
      @member.user_id = @user.id
      flash[:notice] = "New user added and invitation email sent to #{@user.email}."
      redirect_to @user.member
    else
      flash[:error] = "errors occurred!"
      redirect_to members_url
      #@member = Member.new( member_params ) # only used if need to revisit form
      #render :new
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

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end