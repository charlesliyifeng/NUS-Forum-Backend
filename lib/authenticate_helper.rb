module AuthenticateHelper

  def authenticate_user
    render json: { error: "Invalid credentials" }, status: 401 unless @current_user
  end

  def load_current_user
    begin
      email = JsonWebTokenService.decode(request.headers['HTTP_AUTH_TOKEN'])["email"]
      @current_user = User.find_by(email: email)
    rescue JWT::DecodeError
      puts "############################## no auth_token ####################################"
    else
      puts "############################## user signed in ####################################"
    end
  end

  def authenticate_target_user(target)
    # only allow if user is target user or user is admin
    if current_user.id != target.to_i
      render json: {error: "Insufficient privilages"}, status: 403
    end
  end
  
  def user_sign_in?
    !!current_user
  end
  
  def current_user
    @current_user
  end
    
end