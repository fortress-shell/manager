class V1::SessionsController < ApplicationController
  skip_before_action :authorize_user, only: [:create, :index]
  skip_before_action :verify_authenticity_token, only: :index
  after_action :set_index_csrf_cookie, only: :index

  def index
    @authenticated = AuthorizeUser.call(cookies).result.present?.to_json
    render js: "window.SESSION_STATE = #{@authenticated}; "
  end

  def logout
    cookies.delete :token, domain: '.fortress.sh'
    head :ok
  end

  def create
    @command = AuthenticateUser.call(access_code)
    if @command.success?
      result = @command.result
      cookies[:token] = {
        value: result[:token],
        expires: result[:expires],
        domain: '.fortress.sh'
      }
      render status: :created
    else
      render status: :unauthorized
    end
  end

  private

  def set_index_csrf_cookie
    cookies[:_csrf_token] = {
      value: form_authenticity_token,
      domain: '.fortress.sh'
    }
  end

  def access_code
    params.require(:code)
  end
end
