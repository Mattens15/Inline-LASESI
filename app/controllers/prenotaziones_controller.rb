class PrenotazionesController < ApplicationController
  before_action :set_prenotazione, only: [:show, :edit, :update, :destroy]

  # GET /prenotaziones
  # GET /prenotaziones.json
  def index
    @prenotaziones = Prenotazione.all
  end

  # GET /prenotaziones/1
  # GET /prenotaziones/1.json
  def show
  end

  # GET /prenotaziones/new
  def new
    @prenotazione = Prenotazione.new
  end

  # GET /prenotaziones/1/edit
  def edit
  end

  # POST /prenotaziones
  # POST /prenotaziones.json
  def create
    @prenotazione = Prenotazione.new(prenotazione_params)

    respond_to do |format|
      if @prenotazione.save
        format.html { redirect_to @prenotazione, notice: 'Prenotazione was successfully created.' }
        format.json { render :show, status: :created, location: @prenotazione }
      else
        format.html { render :new }
        format.json { render json: @prenotazione.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prenotaziones/1
  # PATCH/PUT /prenotaziones/1.json
  def update
    respond_to do |format|
      if @prenotazione.update(prenotazione_params)
        format.html { redirect_to @prenotazione, notice: 'Prenotazione was successfully updated.' }
        format.json { render :show, status: :ok, location: @prenotazione }
      else
        format.html { render :edit }
        format.json { render json: @prenotazione.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prenotaziones/1
  # DELETE /prenotaziones/1.json
  def destroy
    @prenotazione.destroy
    respond_to do |format|
      format.html { redirect_to prenotaziones_url, notice: 'Prenotazione was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prenotazione
      @prenotazione = Prenotazione.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prenotazione_params
      params.require(:prenotazione).permit(:user_id, :room_id, :time_from, :time_to)
    end
end
