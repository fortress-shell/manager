class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  attr_reader :current_user

  protect_from_forgery with: :exception

  before_action :authorize_user!
  after_action :set_csrf_cookie

  private

  def authorize_user!
    @current_user = AuthorizeUser.call(cookies[:token]).result
    head :unauthorized unless @current_user
  end

  def set_csrf_token
    cookies[:_csrf_token] = form_authenticity_token
  end

  def set_csrf_cookie
    if protect_against_forgery?
      set_csrf_token
    end
  end

  protected

  def verified_request?
    !protect_against_forgery? || request.get? || request.head? ||
      cookies[:_csrf_token] == request.headers['X-CSRF-Token']
  end
end



