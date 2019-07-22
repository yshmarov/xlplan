class ExpencesController < ApplicationController
  before_action :set_expence, only: [:show, :edit, :update, :destroy]

  def index
    @q = Expence.ransack(params[:q])
    @expences = @q.result.includes(:expendable).paginate(:page => params[:page], :per_page => 20).order('created_at DESC')
  end

  def show
    @activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "Expence", trackable_id: @expence).all
  end

  def new
    @expence = Expence.new
  end

  def edit
  end

  def create
    @expence = Expence.new(expence_params)
    respond_to do |format|
      if @expence.save
        format.html { redirect_to @expence, notice: 'Expence was successfully created.' }
        format.json { render :show, status: :created, location: @expence }
      else
        format.html { render :new }
        format.json { render json: @expence.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @expence.update(expence_params)
        format.html { redirect_to @expence, notice: 'Expence was successfully updated.' }
        format.json { render :show, status: :ok, location: @expence }
      else
        format.html { render :edit }
        format.json { render json: @expence.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @expence.destroy
    respond_to do |format|
      format.html { redirect_to expences_url, notice: 'Expence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_expence
      @expence = Expence.friendly.find(params[:id])
    end

    def expence_params
      params.require(:expence).permit(:tenant_id, :amount, :amount_cents, :payment_method, :expendable_type, :expendable_id, :slug)
    end
end