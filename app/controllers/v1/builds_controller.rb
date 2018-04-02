class V1::BuildsController < ApplicationController
  before_action :set_build, except: :index

  def index
    @builds = @current_user.builds.find_by_project_id(params[:project_id])
  end

  def show
  end

  def restart
    @restart_build = RestartBuild.call(@build)
    render status: :bad_request if @restart_build.failure?
  end

  def cancel
    @cancel_build = CancelBuild.call(@build)
    render status: :bad_request if @cancel_build.failure?
  end

  private

  def set_build
    @build = @current_user.builds.find_by(build_params)
  end

  def build_params
    params.permit(:id, :project_id)
  end
end
