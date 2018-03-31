class V1::ProjectsController < ApplicationController
  def index
    @projects = @current_user.projects
  end

  def show
    @project = @current_user.projects.find(project_params)
  end

  def project_params
    params.require(:id)
  end
end
