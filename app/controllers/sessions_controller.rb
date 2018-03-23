class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :show
  # def index
  #   MessageBus.publish({id: 1, status: 1})
  #   UserMailer.welcome_email.deliver_later(wait_until: 1.hours.from_now)
  #   render json: {id: 1, status: 1}
  # end

  # def destroy
  #   @current_user.sessions.find(params[:session_id]).destroy
  # end

  # def index
  #   @sessions = @current_user.sessions
  # end

  def show
    @session = @current_user.find(@token)
    render js: <<~EOF
      var SESSION_STATE = #{@session.to_json};
    EOF
  end

  # def logout
  #   @session.invalidate
  #   cookies.delete :token, domain: '.fortress.sh'
  # end

  def signin
    user = User.from_github_code(github_params)
    @session = user.sessions.create
    cookies[:token] = {
      value: @session.token,
      expires: @session.expires,
      domain: '.fortress.sh'
    }
    cookies[:payload] = {
      value: @session.token,
      expires: @session.expires,
      domain: '.fortress.sh'
    }
  end
end
