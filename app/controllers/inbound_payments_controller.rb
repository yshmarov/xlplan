class InboundPaymentsController < ApplicationController
  before_action :set_inbound_payment, only: [:show, :edit, :update, :destroy]

  def index
    @inbound_payments = InboundPayment.all
  end

  def show
  end

  def new
    @inbound_payment = InboundPayment.new
  end

  def edit
  end

  def create
    @inbound_payment = InboundPayment.new(inbound_payment_params)
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
      params.require(:inbound_payment).permit(:tenant_id, :event_id, :client_id, :amount, :payment_method)
    end
end
