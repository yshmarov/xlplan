class ExpencesController < ApplicationController
  before_action :set_expence, only: [:show, :edit, :update, :destroy]

  # GET /expences
  # GET /expences.json
  def index
    @expences = Expence.all
  end

  # GET /expences/1
  # GET /expences/1.json
  def show
  end

  # GET /expences/new
  def new
    @expence = Expence.new
  end

  # GET /expences/1/edit
  def edit
  end

  # POST /expences
  # POST /expences.json
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

  # PATCH/PUT /expences/1
  # PATCH/PUT /expences/1.json
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

  # DELETE /expences/1
  # DELETE /expences/1.json
  def destroy
    @expence.destroy
    respond_to do |format|
      format.html { redirect_to expences_url, notice: 'Expence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expence
      @expence = Expence.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expence_params
      params.require(:expence).permit(:tenant_id, :amount, :payment_method, :expendable_type, :expendable_id, :slug)
    end
end
