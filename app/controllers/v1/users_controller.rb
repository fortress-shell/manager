class V1::UsersController < ApplicationController
  def suicide
    @current_user.destroy
    cookies.delete :token, domain: '.fortress.sh'
    head :ok
  end
end
