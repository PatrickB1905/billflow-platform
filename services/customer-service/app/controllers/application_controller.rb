class ApplicationController < ActionController::API
  include ExceptionHandler

  before_action :authorize_request

  private

  def authorize_request
    header = request.headers['Authorization']
    header = header.split.last if header
    raise ExceptionHandler::MissingToken, 'Missing token' unless header

    decoded = JsonWebToken.decode(header)
    @current_user = User.find(decoded[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    raise ExceptionHandler::AuthenticationError, "Invalid token: #{e.message}"
  rescue StandardError => e
    raise ExceptionHandler::AuthenticationError, e.message
  end
end
