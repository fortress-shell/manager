class TokenManager
  def self.generate_token payload
    JWT.encode payload, Rails.application.secrets.jwt_public_key, 'RSA256'
  end
  def self.decode_token payload
    JWT.decode payload, Rails.application.secrets.jwt_private_key, 'RSA256'
  end
end
