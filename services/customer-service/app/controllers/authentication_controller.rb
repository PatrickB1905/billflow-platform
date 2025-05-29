class AuthenticationController < ApplicationController
  # skip auth for login
  skip_before_action :authorize_request, only: :login

  # POST /auth/login
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        token: token,
        exp: 24.hours.from_now.strftime('%Y-%m-%d %H:%M'),
        user: { id: user.id, email: user.email }
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
