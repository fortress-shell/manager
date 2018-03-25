class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  attr_reader :current_user

  protect_from_forgery with: :exception

  before_action :authorize_user
  after_action :set_csrf_cookie

  private

  def authorize_user
    @current_user = AuthorizeUser.call(cookies).result
    head :unauthorized unless @current_user
  end

  def set_csrf_cookie
    if protect_against_forgery?
      cookies['XSRF-TOKEN'] = {
        value: form_authenticity_token,
        httponly: true,
        domain: '.fortress.sh'
      }
    end
  end
end
