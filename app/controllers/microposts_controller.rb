class MicropostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_micropost, only: %i[show edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]

  # GET /microposts or /microposts.json
  def index
    @micropost = Micropost.new
    @microposts = Micropost.all
    @users_microposts = users_microposts
  end

  # GET /microposts/1 or /microposts/1.json
  def show
    @users_microposts = users_microposts
  end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
  end

  # GET /microposts/1/edit
  def edit
  end

  # POST /microposts or /microposts.json
  def create
    @micropost = current_user.microposts.build(micropost_params)
    respond_to do |format|
      if @micropost.save
        format.html { redirect_to microposts_path, notice: "Micropost was successfully created." }
        format.json { render :show, status: :created, location: @micropost }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /microposts/1 or /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to @micropost, notice: "Micropost was successfully updated." }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1 or /microposts/1.json
  def destroy
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_to microposts_url, notice: "Micropost was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_micropost
    @micropost = Micropost.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def micropost_params
    params.require(:micropost).permit(:content)

  end

  def correct_user
    # does the current user have a friend with an id matching the requested id?
    # yes -> display it
    # no -> error
    @post = current_user.microposts.find_by(id: params[:id])
    redirect_to micropost_path, notice: "Not authorized to edit this post." if @post.nil?
  end

  def users_microposts
    if user_signed_in?
      Micropost.where(user_id: current_user.id)
    else
      []
    end
  end
end
