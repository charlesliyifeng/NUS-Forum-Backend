class JsonWebTokenService
  def self.encode(payload, exp = 24.hours.from_now)
    JWT.encode payload, Rails.application.secret_key_base, 'HS256'
  end

  def self.decode(token)
    JWT.decode( token, Rails.application.secret_key_base, algorithm: 'HS256' )[0]
  end
end