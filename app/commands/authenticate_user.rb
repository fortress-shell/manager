class AuthenticateUser
  prepend SimpleCommand

  def initialize(access_code)
    @access_code = access_code
  end

  def call
    JsonWebToken.generate_cookie(user_id: user.id) if user
  end

  private

  def user
    @user ||= generate_user
  end

  def generate_user
    @access_token = generate_access_token[:access_token]
    if @access_token.nil?
      errors.add(:token, 'Access code expired!')
    elsif @user = User.find_by_github_user_id(github_user_id)
      @user.update access_token: @access_token
      @user
    else
      create_user_using_access_token
    end
  end

  def create_user_using_access_token
    User.create!({
      access_token: @access_token,
      github_user_id: github_user_id
    })
  end

  def github_user_id
    @user_id ||= octokit.user[:id]
  end

  def octokit
    @client ||= Octokit::Client.new access_token: @access_token
  end

  def generate_access_token
    Octokit.exchange_code_for_token(@access_code,
         Rails.application.secrets.github_app_id,
         Rails.application.secrets.github_app_secret)
  end
end
