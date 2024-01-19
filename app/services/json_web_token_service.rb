class JsonWebTokenService
  SECRET = "1s#$^aJS1231D76873^&*^Q$oadjhADHhaKJ91(&*839hduiwefvnmAOHgfiuqwb786340sl)&^$ad148"
  def self.encode(payload, exp = 24.hours.from_now)
    JWT.encode( payload, SECRET, 'HS256' )
  end

  def self.decode(token)
    JWT.decode( token, SECRET, algorithm: 'HS256' )[0]
  end
end