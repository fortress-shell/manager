class V1::UsersController < ApplicationController
  def suicide
    @current_user.destroy
  end
end
