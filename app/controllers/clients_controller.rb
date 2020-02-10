class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @ransack_clients = Client.ransack(params[:clients_search], search_key: :clients_search)
    @clients = @ransack_clients.result.includes(:client_tags).paginate(:page => params[:page], per_page: 15).order("created_at DESC")
    @ransack_path = clients_path
  end

  def bday_today
    @ransack_clients = Client.bday_today.search(params[:clients_search], search_key: :clients_search)
    @clients = @ransack_clients.result.includes(:client_tags).paginate(:page => params[:page], per_page: 15).order("created_at DESC")
    @ransack_path = bday_today_clients_path
    render 'index'
  end

  def untagged
    @ransack_clients = Client.untagged.search(params[:clients_search], search_key: :clients_search)
    @clients = @ransack_clients.result.includes(:client_tags).paginate(:page => params[:page], per_page: 15).order("created_at DESC")
    @ransack_path = untagged_clients_path
    render 'index'
  end

  def debtors
    #with negative balance
    @ransack_clients = Client.debtors.search(params[:clients_search], search_key: :clients_search)
    @clients = @ransack_clients.result.includes(:client_tags).paginate(:page => params[:page], per_page: 15).order("created_at DESC")
    @ransack_path = debtors_clients_path
    render 'index'
  end

  def no_gender
    #gender is undisclosed
    @ransack_clients = Client.no_gender.search(params[:clients_search], search_key: :clients_search)
    @clients = @ransack_clients.result.includes(:client_tags).paginate(:page => params[:page], per_page: 15).order("created_at DESC")
    @ransack_path = no_gender_clients_path
    render 'index'
  end

  def no_events
    #gender is undisclosed
    @ransack_clients = Client.no_events.search(params[:clients_search], search_key: :clients_search)
    @clients = @ransack_clients.result.includes(:client_tags).paginate(:page => params[:page], per_page: 15).order("created_at DESC")
    @ransack_path = no_events_clients_path
    render 'index'
  end

  #def no_future_events
  #  #gender is undisclosed
  #  @ransack_clients = Client.no_future_events.search(params[:clients_search], search_key: :clients_search)
  #  @clients = @ransack_clients.result.paginate(:page => params[:page], per_page: 15).order("created_at DESC")
  #  @ransack_path = no_future_events_clients_path
  #  render 'index'
  #end

  def show
    authorize @client
    @events = @client.events.includes(:jobs, :jobs => [:service, :member]).order("starts_at DESC")
    #@events = @client.events.order("starts_at DESC")
    @transactions = @client.transactions.order("created_at DESC")

    @commentable = @client
    @comments = @commentable.comments
    @comment = Comment.new

    @leads = @client.leads

    @event = Event.new
    @services = Service.includes(:service_category)
    authorize @event
    @event.jobs.build

    @transaction = Transaction.new
    authorize @transaction

    @activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "Client", trackable_id: @client).all

    respond_to do |format|
        format.html
        format.pdf do
          render pdf: "Client #{@client.full_name}",
          page_size: 'A4',
          template: "clients/show.pdf.haml",
          layout: "pdf.haml",
          orientation: "Portrait",
          lowquality: true,
          zoom: 1,
          dpi: 75
        end
    end
  end

  def edit
    authorize @client
  end

  def new
    @client = Client.new
    authorize @client
  end

  def create
    @client = Client.new(client_params)
    authorize @client
    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @client
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @client
    @client.destroy
    if @client.errors.present?
      redirect_to @client, alert: 'Client has associations. Can not delete.'
    else
      redirect_to clients_url, notice: 'Client was successfully destroyed.'
    end
  end

  private
    def set_client
      @client = Client.friendly.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:first_name, :last_name, :date_of_birth, :gender, :email, :code,
                                     :phone_number, :lead_source,
                                     :personal_data_consent, :event_created_notifications, :marketing_notifications,
                                     :avatar, 
                                     :country, :city, :zip, :address,
                                     tag_ids: [])
    end
end