class CashAccountsController < ApplicationController
  before_action :set_cash_account, only: [:show, :edit, :update, :destroy]

  def index
    @cash_accounts = CashAccount.all
  end

  def new
    @cash_account = CashAccount.new
  end

  def edit
  end

  def create
    @cash_account = CashAccount.new(cash_account_params)
    respond_to do |format|
      if @cash_account.save
        format.html { redirect_to cash_accounts_url, notice: 'Cash account was successfully created.' }
        format.json { render :show, status: :created, location: @cash_account }
      else
        format.html { render :new }
        format.json { render json: @cash_account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cash_account.update(cash_account_params)
        format.html { redirect_to cash_accounts_url, notice: 'Cash account was successfully updated.' }
        format.json { render :show, status: :ok, location: @cash_account }
      else
        format.html { render :edit }
        format.json { render json: @cash_account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cash_account.destroy
    respond_to do |format|
      format.html { redirect_to cash_accounts_url, notice: 'Cash account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_cash_account
      @cash_account = CashAccount.friendly.find(params[:id])
    end

    def cash_account_params
      params.require(:cash_account).permit(:name, :active)
    end
end