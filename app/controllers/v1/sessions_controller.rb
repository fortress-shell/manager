class V1::SessionsController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: :index
  # skip_before_action :authorize_user, only: [:index, :create]

  def index
    render js: "window.SESSION_STATE = #{@current_user.to_json};"
  end

  def destroy
    cookies.delete :token, domain: '.fortress.sh'
    head :ok
  end

  def create
    @command = AuthenticateUser.call(access_code)

    if command.success?
      result = @command.result
      cookies[:token] = {
        value: result.token,
        expires: result.expires,
        domain: '.fortress.sh'
      }
      render status: :created
    else
      render status: :unauthorized
    end
  end

  private

  def access_code
    params[:code]
  end
end
