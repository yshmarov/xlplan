class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :destroy]

  def index
    @q = Transaction.ransack(params[:q])
    @transactions = @q.result.includes(:client).paginate(:page => params[:page], per_page: 15).order('created_at DESC')
  end

  def show
    authorize @transaction
    @activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "Transaction", trackable_id: @transaction).all
    respond_to do |format|
        format.html
        format.pdf do
          render pdf: "Payment No. #{@transaction.slug}",
          page_size: 'A6',
          template: "transactions/show.pdf.haml",
          #template: "transactions/transaction_pdf.html.haml",
          #template: "transactions/show.html.haml",
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
    @transaction = Transaction.new
    @clients = Client.all
    authorize @transaction
  end

  def create
    @transaction = Transaction.new(transaction_params)
    authorize @transaction
    respond_to do |format|
      if @transaction.save
        if @transaction.payable_id.present?
          format.html { redirect_to @transaction.payable, notice: 'Inbound payment was successfully created.' }
        else
          format.html { redirect_to @transaction.client, notice: 'Inbound payment was successfully created.' }
          format.json { render :show, status: :created, location: @transaction }
        end
      else
        @clients = Client.all
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @transaction
    @transaction.destroy
    if @transaction.payable_id.present?
      redirect_to @transaction.payable, notice: 'Inbound payment was successfully destroyed.'
    else
      respond_to do |format|
        format.html { redirect_to @transaction.client, notice: 'Inbound payment was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    def set_transaction
      @transaction = Transaction.friendly.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:tenant_id, :client_id, :amount, :amount_cents, :payment_method, :payable_id, :payable_type)
      #params.require(:transaction).permit(:tenant_id, :client_id, :amount, :amount_cents, :payment_method)
    end
end
