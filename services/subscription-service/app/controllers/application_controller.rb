class ApplicationController < ActionController::API
  include ExceptionHandler
  before_action :authorize_request

  private

  def authorize_request
    token = request.headers['Authorization']&.split&.last
    raise MissingToken, 'Missing token' unless token

    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id])
  rescue ActiveRecord::RecordNotFound  => e
    raise AuthenticationError, "Invalid token: #{e.message}"
  rescue StandardError => e
    raise AuthenticationError, e.message
  end
end
