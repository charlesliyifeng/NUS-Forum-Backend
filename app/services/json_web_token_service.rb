class JsonWebTokenService
  SECRET = "helloworld123"
  def self.encode(payload, exp = 24.hours.from_now)
    JWT.encode( payload, SECRET, 'HS256' )
  end

  def self.decode(token)
    JWT.decode( token, SECRET, algorithm: 'HS256' )[0]
  end
end