class InboundPaymentsController < ApplicationController
  before_action :set_inbound_payment, only: [:show, :edit, :update, :destroy]

  def index
    @inbound_payments = InboundPayment.all.paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
  end

  def show
    authorize @inbound_payment
    @activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "InboundPayment", trackable_id: @inbound_payment).all
  end

  def new
    @inbound_payment = InboundPayment.new
    authorize @inbound_payment
  end

  def edit
    authorize @inbound_payment
  end

  def create
    @inbound_payment = InboundPayment.new(inbound_payment_params)
    authorize @inbound_payment
    respond_to do |format|
      if @inbound_payment.save
        format.html { redirect_to @inbound_payment, notice: 'Inbound payment was successfully created.' }
        format.json { render :show, status: :created, location: @inbound_payment }
      else
        format.html { render :new }
        format.json { render json: @inbound_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @inbound_payment
    respond_to do |format|
      if @inbound_payment.update(inbound_payment_params)
        format.html { redirect_to @inbound_payment, notice: 'Inbound payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @inbound_payment }
      else
        format.html { render :edit }
        format.json { render json: @inbound_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @inbound_payment
    @inbound_payment.destroy
    respond_to do |format|
      format.html { redirect_to inbound_payments_url, notice: 'Inbound payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_inbound_payment
      @inbound_payment = InboundPayment.find(params[:id])
    end

    def inbound_payment_params
      params.require(:inbound_payment).permit(:tenant_id, :client_id, :amount, :amount_cents, :payment_method)
    end
end
