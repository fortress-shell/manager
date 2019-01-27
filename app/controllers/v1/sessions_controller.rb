class V1::SessionsController < ApplicationController
  skip_before_action :authorize_user!, only: [:create, :index]
  skip_before_action :verify_authenticity_token, only: :index
  after_action :set_csrf_token, only: :index

  def index
    authenticated = AuthorizeUser.call(cookies[:token]).result.present?
    render js: "window.SESSION_STATE = #{authenticated.to_json}; "
  end

  def logout
    cookies.delete :token
    head :ok
  end

  def create
    @authenticate_user = AuthenticateUser.call(params[:code])
    if @authenticate_user.success?
      cookies[:token] = @authenticate_user.result
      render status: :created
    else
      render status: :unauthorized
    end
  end
end
