class JsonWebToken
  SECRET_KEY = ENV.fetch('JWT_SECRET') { Rails.application.credentials.secret_key_base }

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    decoded.with_indifferent_access
  rescue JWT::DecodeError, JWT::ExpiredSignature => e
    raise StandardError, e.message
  end
end
