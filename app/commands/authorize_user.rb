class AuthorizeUser
  prepend SimpleCommand

  def initialize(cookies = {})
    @cookies = cookies
  end

  def call
    user
  end

  private

  attr_reader :cookies

  def user
    return User.find_by_id(token_payload['user_id']) if token_payload
    errors.add(:token, 'Invalid token')
  end

  def token_payload
    @payload ||= JsonWebToken.decode(token_from_cookies)[0]
  rescue JWT::DecodeError
    nil
  end

  def token_from_cookies
    if cookies[:token].present?
      puts cookies[:token]
      return cookies[:token]
    else
      errors.add(:token, 'Missing token')
      nil
    end
  end
end
