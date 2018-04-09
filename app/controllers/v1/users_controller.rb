class V1::UsersController < ApplicationController
  def suicide
    @current_user.destroy
    cookies.delete :token
    head :ok
  end
end
