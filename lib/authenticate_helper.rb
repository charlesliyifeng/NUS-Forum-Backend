module AuthenticateHelper

  def authenticate_user
    email = JsonWebTokenService.decode(request.headers['HTTP_AUTH_TOKEN'])["email"]
    @current_user = User.find_by(email: email)
      
    render json: { error: "Not Authorized" }, status: 401 unless @current_user
  end

  def authenticate_target_user(target)
    # only allow if user is target user or user is admin
    render json: {error: "Not Authorized" }, status: 401 unless (@current_user.id == target) # or is an admin
  end
  
  def user_sign_in?
    !!current_user
  end
  
  def current_user
    @current_user
  end
    
end