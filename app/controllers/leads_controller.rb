class LeadsController < ApplicationController
  before_action :set_lead, only: [:show, :edit, :update, :destroy]
  include Pagy::Backend

  def index
    #@leads = Lead.all.order('created_at DESC')
    @pagy, @leads = pagy(Lead.all.order('created_at DESC'))
  end

  def show
  end

  def edit
    #for form
    @members = Member.active.online_booking.order('created_at ASC')
    @locations = Location.active.online_booking.order(events_count: :desc)
    @services = Service.online_booking.active
  end

	def create_client_from_lead
    #SELECT A lead AND CONVERT HIM INTO A CLIENT
	  @lead = Lead.find(params[:id])
	  @client = Client.new
  	  @client.first_name = @lead.first_name
  	  @client.last_name = @lead.last_name
  	  @client.email = @lead.email
  	  @client.phone_number = @lead.phone_number
  	  @client.lead_source = "online_booking"
  	  @client.save
		@lead.update_attribute(:client_id, @client.id)

    if @client.save
      redirect_to leads_path, notice: 'Client was successfully created.'
    else
      redirect_to leads_path, alert: 'Error.'
    end
	end

  def update
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to @lead, notice: 'Lead was successfully updated.' }
        format.json { render :show, status: :ok, location: @lead }
      else
        format.html { render :edit }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @lead
    @lead.destroy
    respond_to do |format|
      if @lead.client.present?
        format.html { redirect_to @lead.client, notice: 'Lead was successfully destroyed.' }
      else
        format.html { redirect_to leads_url, notice: 'Lead was successfully destroyed.' }
      end
      format.json { head :no_content }
    end
  end

  private
    def set_lead
      @lead = Lead.friendly.find(params[:id])
    end

    def lead_params
      params.require(:lead).permit(:first_name, :last_name, :phone_number, :email, :comment, :location_id, :member_id, :service_id, :starts_at, :coupon, :conditions_consent)
    end
end