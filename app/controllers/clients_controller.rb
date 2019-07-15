class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def search
    index
    render :index
  end

  def index
    #@client = Client.new
    @ransack_clients = Client.search(params[:clients_search], search_key: :clients_search)
    @clients = @ransack_clients.result.paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
  end

  def contacts_callback
    @contacts = request.env['omnicontacts.contacts']
    @user = request.env['omnicontacts.user']
    puts "List of contacts of #{@user[:name]} obtained from #{params[:importer]}:"
    @contacts.each do |contact|
      puts "Contact found: name => #{contact[:name]}, email => #{contact[:email]}"
    end

    #@contacts = request.env['omnicontacts.contacts']
    #@user = request.env['omnicontacts.user']
    #puts "List of contacts of #{@user[:name]} obtained from #{params[:importer]}:"
    #@contacts.each do |contact|
    #  puts "Contact found: name => #{contact[:name]}, email => #{contact[:email]}"
    #end
  end

  def debtors
    #with negative balance
    @ransack_clients = Client.where("balance < ?", 0).search(params[:clients_search], search_key: :clients_search)
    @clients = @ransack_clients.result.paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
    render 'index'
  end

  def show
    authorize @client
    #@jobs = @client.jobs
    @events = @client.events.order("starts_at DESC")
    @inbound_payments = @client.inbound_payments.order("created_at DESC")

    @commentable = @client
    @comments = @commentable.comments
    @comment = Comment.new

    @next_event = @client.events.where("starts_at >= ?", Time.zone.now).order("starts_at ASC").pluck(:starts_at).first
    @last_event = @client.events.where("starts_at <= ?", Time.zone.now).order("starts_at DESC").pluck(:starts_at).first

    @event = Event.new
    authorize @event
    @event.jobs.build

    @inbound_payment = InboundPayment.new
    authorize @inbound_payment

    #@activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "Client", trackable_id: @client).all
  end

  def new
    @client = Client.new
    authorize @client
  end

  def edit
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
      redirect_to clients_url, alert: 'Client has associated jobs. Can not delete.'
    else
      redirect_to clients_url, notice: 'Client was successfully destroyed.'
    end
  end

  private
    def set_client
      @client = Client.friendly.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:first_name, :last_name, :date_of_birth, :gender, :email, :phone_number, :status, :balance, address: [:country, :city, :street, :zip])
    end
end