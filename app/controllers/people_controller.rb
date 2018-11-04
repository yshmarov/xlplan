class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy, :invite_user]

	def invite_user
    @user = User.invite!(email: @person.email, person_id: @person.id)
		redirect_to people_url
    #redirect_to user_invitation_path
    #if @user.save
    #  redirect_to @person, notice: 'Invited.'
    #else
    #  redirect_to @person, notice: 'Not invited.'
    #end
    #= simple_form_for(User.new, url: user_invitation_path) do |z|
    #  = z.input :email, input_html: {value: person.email}, as: :hidden
    #  = z.input :person_id, input_html: {value: person.id}, as: :hidden
    #  = z.button :submit, 'Invite', class: "btn btn-success btn-xs"
		#redirect_to @person, notice: "User invited"
		#redirect_to @person
	end

  def index
    @people = Person.all
  end

  def show
  end

  def new
    @person = Person.new
  end

  def edit
  end

  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:first_name, :middle_name, :last_name, :date_of_birth, :sex, :email, :phone_number, :address, :description, :status)
    end
end
