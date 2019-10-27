class CashoutsController < ApplicationController
  before_action :set_cashout, only: [:show, :destroy]

  def index
    @cashouts = Cashout.all
  end

  def new
    @cashout = Cashout.new
  end

  def create
    @cashout = Cashout.new(cashout_params)

    respond_to do |format|
      if @cashout.save
        format.html { redirect_to @cashout, notice: 'Cashout was successfully created.' }
        format.json { render :show, status: :created, location: @cashout }
      else
        format.html { render :new }
        format.json { render json: @cashout.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cashout.destroy
    respond_to do |format|
      format.html { redirect_to cashouts_url, notice: 'Cashout was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_cashout
      @cashout = Cashout.find(params[:id])
    end

    def cashout_params
      params.require(:cashout).permit(:location_id, :amount, :member_id, :amount_cents)
    end
end
