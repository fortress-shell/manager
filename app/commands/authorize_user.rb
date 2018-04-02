class AuthorizeUser
  prepend SimpleCommand

  def initialize(token)
    @token = token
  end

  def call
    return User.find_by_id(token_payload['user_id']) if token_payload
    errors.add(:token, 'Invalid token')
  end

  private

  def token_payload
    @payload ||= JsonWebToken.decode(token_from_cookies)[0]
  rescue JWT::DecodeError
    nil
  end

  def token_from_cookies
    if @token.present?
      @token
    else
      errors.add(:token, 'Missing token')
      nil
    end
  end
end
