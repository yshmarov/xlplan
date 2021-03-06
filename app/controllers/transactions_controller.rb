class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :destroy]
  include Pagy::Backend

  def index
    @q = Transaction.ransack(params[:q])
    @pagy, @transactions = pagy(@q.result.order("created_at DESC"))
  end

  def show
    authorize @transaction
    @activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "Transaction", trackable_id: @transaction).all
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Payment No. #{@transaction.slug}",
               page_size: "A6",
               template: "transactions/show.pdf.haml",
               # template: "transactions/transaction_pdf.html.haml",
               # template: "transactions/show.html.haml",
               # format.pdf {render template: "payments/report", pdf: 'report'}   # Excluding ".pdf" extension.
               # format.pdf {render template: "projects/report", pdf: "invoice #{@project.id}"}
               layout: "pdf.html.haml",
               orientation: "Portrait",
               lowquality: true,
               zoom: 1,
               dpi: 75
      end
    end
  end

  def new
    @transaction = Transaction.new
    @cash_accounts = CashAccount.order("created_at ASC")
    @clients = Client.all
    authorize @transaction
  end

  def create
    @transaction = Transaction.new(transaction_params)
    authorize @transaction
    respond_to do |format|
      if @transaction.save
        if @transaction.payable_id.present?
          format.html { redirect_to @transaction.payable, notice: "Payment was successfully created." }
        else
          format.html { redirect_to @transaction.client, notice: "Payment was successfully created." }
          format.json { render :show, status: :created, location: @transaction }
        end
      else
        @clients = Client.all
        @cash_accounts = CashAccount.order("created_at ASC")
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @transaction
    @transaction.destroy
    if @transaction.payable_id.present?
      redirect_to @transaction.payable, notice: "Payment was successfully destroyed."
    else
      respond_to do |format|
        format.html { redirect_to @transaction.client, notice: "Payment was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private

  def set_transaction
    @transaction = Transaction.friendly.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:tenant_id, :cash_account_id,
      :amount, :amount_cents,
      :payable_id, :payable_type,
      :comment)
  end
end
