class JsonWebToken
  def self.encode(payload, expires = 24.hours.from_now)
    payload[:exp] = expires.to_i
    {
      token: JWT.encode(payload, Rails.application.secrets.secret_key),
      expires: expires
    }
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key)
  end
end
