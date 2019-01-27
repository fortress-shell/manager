class JsonWebToken
  SECRET = Rails.application.secrets.secret_key

  def self.generate_cookie(payload, cookies = { expires: 24.hours.from_now.utc })
    cookies.merge(value: encode(payload.merge(exp: cookies[:expires])))
  end
  
  def self.encode(payload)
    JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    JWT.decode(token, SECRET)
  end
end
