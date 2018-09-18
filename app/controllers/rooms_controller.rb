class RoomsController < ApplicationController
  before_action :set_room, only: [:edit, :update, :destroy, :destroy_avatar]
  before_action :logged_in_user, only: [:new]
  before_action :correct_user, only: [:edit, :destroy]
  
  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all 
  end
  
  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @room = Room.friendly.find(params[:id])
    @reservations = @room.reservations
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      respond_to do |format|
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        flash[:success] = 'Room updated!'
        format.html { redirect_to edit_room_path(@room), success: 'Room was successfully updated.' }
        format.json { render :edit, status: :ok, location: @room }
      else
        flash[:danger] = 'Parametri non validi!'
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_avatar
    @room.avatar.destroy
    @room.save!
    redirect_to edit_room_path(@room)
  end

  def invite_user_to_room
    room=Room.find_by(id: params[:room_id])
    sender=current_user
    sendee=User.find_by(username: params[:username])
    if sendee
      sender.send_message(sendee,"You have been invited to #{room.name}",
    "Hey #{sendee.username}, #{sender.username} has invited you to check out root_url/rooms/#{@room.hash_id}")
      respond_to do |format|
        format.html{redirect_to room,notice: 'User has been invited!'}
      end
    else
      respond_to do |format|
        format.html{redirect_to room,notice: 'ERROR: User does not exist'}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :description, :recurrence, :address, :max_participants, :latitude, :longitude, :time_from, :time_to, :avatar, :datetime, :user_id, :fifo, :private, :delete_avatar, :recurrence)
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
     def correct_user
      redirect_to(root_url) unless (!current_user.nil? && current_user.powers.exists?(room_id: @room.id))
    end
end

