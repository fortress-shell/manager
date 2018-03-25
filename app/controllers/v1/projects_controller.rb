class V1::ProjectsController < ApplicationController
  def index
    @projects = @current_user.projects
  end
end
