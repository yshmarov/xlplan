class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    #@ransack_clients = Client.ransack(params[:q])
    #@clients = @ransack_clients.result(distinct: true).paginate(:page => params[:page], :per_page => 10)

    @ransack_clients = Client.search(params[:clients_search], search_key: :clients_search)
    @clients = @ransack_clients.result.includes(:employee).paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
  end

  def show
    authorize @client
    @jobs = @client.jobs
    @commentable = @client
    @comments = @commentable.comments
    @comment = Comment.new
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
    #@client.employee_id = current_user.employee.id

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
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:first_name, :middle_name, :last_name, :date_of_birth, :gender, :email, :phone_number, :address, :description, :status, :balance, :employee_id)

    end
end
