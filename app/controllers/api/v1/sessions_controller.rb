class Api::V1::SessionsController < ApplicationController
  include JSONAPI::Fetching

  skip_before_action :authenticate_user, only: [:create]

  # GET /sessions (get current user)
  def index
    render jsonapi: current_user
  end

  # Login user into application
  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password]) # User exist and check password is match 
      token = JsonWebTokenService.encode({ email: @user.email })
      render json: { user_id: @user.id, username: @user.name, auth_token: token }
    else
      render json: { error: "Incorrect Email Or password" }, status: :unauthorized
    end
  end

  # Log out user from application
  def destroy
    render json: { user_id: current_user.id }
  end

end
