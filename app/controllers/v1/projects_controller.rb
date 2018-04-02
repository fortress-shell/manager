class V1::ProjectsController < ApplicationController
  def index
    @projects = @current_user.projects
  end

  def show
    @project = @current_user.projects.find(params[:id])
  end
end
