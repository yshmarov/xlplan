class LeadsController < ApplicationController
  before_action :set_lead, only: [:create_client_from_lead, :destroy]
  include Pagy::Backend

  def index
    @pagy, @leads = pagy(Lead.all.order('created_at DESC'))
  end

  def create # start wizard
    @lead = Lead.create(status: "start")
    redirect_to lead_booking_wizard_index_path(:select_location, lead_id: @lead.id)
  end

	def create_client_from_lead #new client
	  @client = Client.new
  	  @client.first_name = @lead.first_name
  	  @client.last_name = @lead.last_name
  	  @client.email = @lead.email
  	  @client.phone_number = @lead.phone_number
  	  @client.lead_source = "online_booking"
  	  @client.save
		@lead.update_attribute(:client_id, @client.id)
    if @client.save
      ClientTag.create(client: @client, tag: Tag.find_by(name: "contact_required"))
      redirect_to leads_path, notice: 'Client was successfully created.'
    else
      redirect_to leads_path, alert: 'Error.'
    end
	end

  def destroy
    authorize @lead
    @lead.destroy
    if @lead.client.present?
      redirect_to @lead.client, notice: 'Lead was successfully destroyed.'
    else
      redirect_to leads_url, notice: 'Lead was successfully destroyed.'
    end
  end

  private
    def set_lead
      @lead = Lead.friendly.find(params[:id])
    end
end