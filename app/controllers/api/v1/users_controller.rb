class Api::V1::UsersController < ApplicationController
  include JSONAPI::Fetching

  skip_before_action :authenticate_user, only: %i[ show create index ]
  before_action :set_user, only: %i[ show update destroy ]
  before_action :check_user_privilage, only: %i[ update destroy ]
  
  # GET /users ( for testing only )
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1 ( Get Profile of 1 user )
  def show
    render jsonapi: @user
  end

  # POST /users ( Create user )
  def create
    @user = User.new(user_params)
    if @user.save
      render json: { success: "User created" }, status: :ok
    else
      render json: { error: @user.errors.messages.map { |msg, desc| msg.to_s + " " + desc[0] }.join(',') }, status: :unauthorized
    end
  end

  # PATCH/PUT /users/1 ( Update account details )
  def update
    @user.assign_attributes(user_params)
    if @user.save(validate: false)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  # DELETE /users/1 ( Delete Your Account )
  def destroy
    if @user.destroy
      render json: { success: "Successfully deleted" }, status: :ok
    else
      render json: { error: "Something went wrong" }, status: :not_found
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      unless @user
        render json: { error: "User not found" }, status: :not_found
      end
    end

    # check user access
    def check_user_privilage
      authenticate_target_user(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
