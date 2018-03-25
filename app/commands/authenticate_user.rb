class AuthenticateUser
  prepend SimpleCommand

  def initialize(access_code)
    @access_code = access_code
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :access_code

  def user
    @user ||= generate_token
  end

  def generate_token
    token = generate_access_token

    if user_exists = User.find_by_access_token(token[:access_token])
      user_exists
    else
      create_user_using_access_token(token[:access_token])
    end
  end

  def create_user_using_access_token(access_token)
    client = Octokit::Client.new access_token: access_token
    info = client.getUserInfo()
    user = User.create! info
    UserMailer.welcome_email.deliver_later(wait_until: 1.hours.from_now)
    user
  end

  def generate_access_token
    Octokit.exchange_code_for_token(access_code,
      Rails.application.secrets.github_app_id,
      Rails.application.secrets.github_app_secret,
      {:accept => 'application/json'})
  end
end
