class HasPowersController < ApplicationController
  before_action :set_has_power, only: [:show, :edit, :update, :destroy]

  # GET /has_powers
  # GET /has_powers.json
  def index
    @has_powers = HasPower.all
  end

  # GET /has_powers/1
  # GET /has_powers/1.json
  def show
  end

  # GET /has_powers/new
  def new
    @has_power = HasPower.new
  end

  # GET /has_powers/1/edit
  def edit
  end

  # POST /has_powers
  # POST /has_powers.json
  def create
    @has_power = HasPower.new(has_power_params)

    respond_to do |format|
      if @has_power.save
        format.html { redirect_to @has_power, notice: 'Has power was successfully created.' }
        format.json { render :show, status: :created, location: @has_power }
      else
        format.html { render :new }
        format.json { render json: @has_power.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /has_powers/1
  # PATCH/PUT /has_powers/1.json
  def update
    respond_to do |format|
      if @has_power.update(has_power_params)
        format.html { redirect_to @has_power, notice: 'Has power was successfully updated.' }
        format.json { render :show, status: :ok, location: @has_power }
      else
        format.html { render :edit }
        format.json { render json: @has_power.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /has_powers/1
  # DELETE /has_powers/1.json
  def destroy
    @has_power.destroy
    respond_to do |format|
      format.html { redirect_to has_powers_url, notice: 'Has power was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_has_power
      @has_power = HasPower.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def has_power_params
      params.require(:has_power).permit(:user_id, :room_id)
    end
end
