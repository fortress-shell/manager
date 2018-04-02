class JsonWebToken
  class << self
    def encode(payload, expires = 24.hours.from_now.utc)
      payload[:exp] = expires.to_i
      {
        token: JWT.encode(payload, Rails.application.secrets.secret_key),
        expires: expires
      }
    end

    def decode(token)
      JWT.decode(token, Rails.application.secrets.secret_key)
    end
  end
end
