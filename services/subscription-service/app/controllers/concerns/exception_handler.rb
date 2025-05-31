module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken      < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound,  with: :render_not_found
    rescue_from AuthenticationError,            with: :render_unauthorized
    rescue_from MissingToken,                   with: :render_unauthorized
  end

  private

  def render_unprocessable_entity(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def render_not_found(e)
    render json: { error: e.message }, status: :not_found
  end

  def render_unauthorized(e)
    render json: { error: e.message }, status: :unauthorized
  end
end
