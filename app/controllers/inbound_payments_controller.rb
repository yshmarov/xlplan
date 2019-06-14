class InboundPaymentsController < ApplicationController
  before_action :set_inbound_payment, only: [:show, :destroy]

  def index
    @q = InboundPayment.ransack(params[:q])
    @inbound_payments = @q.result.includes(:client).paginate(:page => params[:page], :per_page => 20).order('created_at DESC')
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
        if @inbound_payment.payable_id.present?
          format.html { redirect_to @inbound_payment.payable, notice: 'Inbound payment was successfully created.' }
        else
          format.html { redirect_to @inbound_payment, notice: 'Inbound payment was successfully created.' }
          format.json { render :show, status: :created, location: @inbound_payment }
        end
      else
        format.html { render :new }
        format.json { render json: @inbound_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @inbound_payment
    @inbound_payment.destroy
    if @inbound_payment.payable_id.present?
      redirect_to @inbound_payment.payable, notice: 'Inbound payment was successfully destroyed.'
    else
      respond_to do |format|
        format.html { redirect_to inbound_payments_url, notice: 'Inbound payment was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    def set_inbound_payment
      @inbound_payment = InboundPayment.friendly.find(params[:id])
    end

    def inbound_payment_params
      params.require(:inbound_payment).permit(:tenant_id, :client_id, :amount, :amount_cents, :payment_method, :payable_id, :payable_type)
      #params.require(:inbound_payment).permit(:tenant_id, :client_id, :amount, :amount_cents, :payment_method)
    end
end
