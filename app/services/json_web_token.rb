class JsonWebToken
  SECRET = ENV.fetch('SECRET')

  def self.encode(payload, expires = 24.hours.from_now)
    payload[:exp] = expires.to_i
    {
      token: JWT.encode(payload, SECRET),
      expires: expires
    }
  end

  def self.decode(token)
    JWT.decode(token, SECRET)
  end
end
