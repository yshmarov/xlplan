class WorkplacesController < ApplicationController
  before_action :set_workplace, only: [:show, :edit, :update, :destroy]

  def index
    @workplaces = Workplace.all
  end

  def show
    authorize @workplace
    @jobs = @workplace.location.jobs
  end

  def new
    @workplace = Workplace.new
    authorize @workplace
  end

  # GET /workplaces/1/edit
  def edit
    authorize @workplace
  end

  # POST /workplaces
  # POST /workplaces.json
  def create
    @workplace = Workplace.new(workplace_params)
    authorize @workplace

    respond_to do |format|
      if @workplace.save
        format.html { redirect_to @workplace, notice: 'Workplace was successfully created.' }
        format.json { render :show, status: :created, location: @workplace }
      else
        format.html { render :new }
        format.json { render json: @workplace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workplaces/1
  # PATCH/PUT /workplaces/1.json
  def update
    authorize @workplace
    respond_to do |format|
      if @workplace.update(workplace_params)
        format.html { redirect_to @workplace, notice: 'Workplace was successfully updated.' }
        format.json { render :show, status: :ok, location: @workplace }
      else
        format.html { render :edit }
        format.json { render json: @workplace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workplaces/1
  # DELETE /workplaces/1.json
  def destroy
    authorize @workplace
    @workplace.destroy
    respond_to do |format|
      format.html { redirect_to workplaces_url, notice: 'Workplace was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workplace
      @workplace = Workplace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workplace_params
      params.require(:workplace).permit(:name, :location_id, :status)
    end
end
