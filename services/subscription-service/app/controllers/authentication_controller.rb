class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :login

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, exp: 24.hours.from_now, user: { id: user.id, email: user.email } }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
end
