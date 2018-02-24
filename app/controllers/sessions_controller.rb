class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :show
  def index
    Bus.publish({id: 1, status: 1})
    UserMailer.welcome_email.deliver_later(wait_until: 1.hours.from_now)
    render json: {id: 1, status: 1}
  end
  # def destroy
  # end
  # def index
  #   cookies[:shit] = 'mymindblow'
  #   send_file '/tmp/app.html', type: 'text/html', disposition: 'inline'
  # end
  def show
    session = @current_user.session_id
    render js: <<~EOF
      window.DEFAULT_STATE = #{session.to_json};
    EOF
  end
  # private def js(state)
  #     default_state = JSON.dump(state)
  #
  #   end

  # def logout
  #   Session.destroy(current_user.session_id)
  # end
  # class Session
  #   def self.create user, exp
  #     session_id = SecureRandom.uuid
  #     $redis.multi do |multi|
  #       multi.set(session_id)
  #       multi.sadd(user.id, session_id)
  #       multi.zadd(:to_be_expired, session_id)
  #     end
  #     {
  #       session_id: session_id,
  #       exp: exp
  #     }
  #   end
  #   def self.destroy(session_id)
  #     $redis.multi do |multi|
  #       multi.del(session_id, user.to_json)
  #       multi.srem(user.id, session_id)
  #       multi.zrem(:to_be_expired, exp, session_id)
  #     end
  #   end
  #   def self.find
  #   end
  # end
  # class TokenManager
  #   def self.generate_token payload
  #     JWT.encode payload, Rails.application.secrets.jwt_public_key, 'RSA256'
  #   end
  #   def self.decode_token payload
  #     JWT.decode payload, Rails.application.secrets.jwt_private_key, 'RSA256'
  #   end
  # end
  # class User
  #   def self.from_github_code(github_params)
  #     hash_with_token = Octokit.exchange_code_for_token \
  #       github_params[:code],
  #       Rails.application.secrets.github_app_id,
  #       Rails.application.secrets.github_app_secret,
  #       {:accept => 'application/json'}
  #     userInfo = Octokit.getUserInfo(token)
  #     create! userInfo
  #   end
  # end
  # def signin
  #   user = User.from_github_code(github_params)
  #   expiration_time = 1.day.from_now
  #   payload = Session.create(user, expiration_time)
  #   token = TokenManager.generate_token(payload, expiration_time)
  #   cookies[:token] = {
  #     value: token,
  #     expires: expiration_time,
  #     domain: '.domain.com'
  #   }
  #   redirect_to '/dashboar'
  # end
end
