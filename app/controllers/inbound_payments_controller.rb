class InboundPaymentsController < ApplicationController
  before_action :set_inbound_payment, only: [:show, :destroy]

  def index
    @q = InboundPayment.ransack(params[:q])
    @inbound_payments = @q.result.includes(:client).paginate(:page => params[:page], per_page: 15).order('created_at DESC')
  end

  def show
    authorize @inbound_payment
    @activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "InboundPayment", trackable_id: @inbound_payment).all
    respond_to do |format|
        format.html
        format.pdf do
          render pdf: "Payment No. #{@inbound_payment.slug}",
          page_size: 'A6',
          template: "inbound_payments/show.pdf.haml",
          #template: "inbound_payments/inbound_payment_pdf.html.haml",
          #template: "inbound_payments/show.html.haml",
          #format.pdf {render template: "payments/report", pdf: 'report'}   # Excluding ".pdf" extension.
          #format.pdf {render template: "projects/report", pdf: "invoice #{@project.id}"}
          layout: "pdf.haml",
          orientation: "Portrait",
          lowquality: true,
          zoom: 1,
          dpi: 75
        end
    end
  end

  def new
    @inbound_payment = InboundPayment.new
    @clients = Client.all
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
          format.html { redirect_to @inbound_payment.client, notice: 'Inbound payment was successfully created.' }
          format.json { render :show, status: :created, location: @inbound_payment }
        end
      else
        @clients = Client.all
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
        format.html { redirect_to @inbound_payment.client, notice: 'Inbound payment was successfully destroyed.' }
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
