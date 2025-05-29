module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken      < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ExceptionHandler::AuthenticationError, with: :render_unauthorized
    rescue_from ExceptionHandler::MissingToken,      with: :render_unauthorized
  end

  private

  def render_unprocessable_entity(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def render_unauthorized(exception)
    render json: { error: exception.message }, status: :unauthorized
  end

  def render_not_found(exception)
  render json: { error: exception.message }, status: :not_found
  end
end



