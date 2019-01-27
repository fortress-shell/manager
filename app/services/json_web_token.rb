class JsonWebToken
  SECRET = Rails.application.secrets.secret_key

  def self.encode(payload, cookies = { expires: 24.hours.from_now.utc } )
    cookies.merge(value: JWT.encode(payload.merge(exp: cookies[:expires]), SECRET))
  end

  def self.decode(token)
    JWT.decode(token, SECRET)
  end
end
