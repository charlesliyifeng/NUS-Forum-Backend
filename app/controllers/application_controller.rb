class ApplicationController < ActionController::API
  include AuthenticateHelper
  before_action :load_current_user
  before_action :authenticate_user
end
