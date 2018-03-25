class V1::BuildsController < ApplicationController
  before_action :set_current_user_build, only: [:restart, :cancel]
  before_action :set_build, except: [:show, :restart, :cancel]
  skip_before_action :authorize_user, except: [:show, :restart, :cancel]

  def index
    @builds = @current_user.builds.find_by_project_id project_id
  end

  def restart
    @command = RestartBuild.call(@current_user_build)
    if @command.failure?
      render status: :bad_request
    end
  end

  def cancel
    @command = CancelBuild.call(@current_user_build)
    if @command.failure?
      render status: :bad_request
    end
  end

  def timeout
    @command = TimeoutBuild.call(@build)
    if @command.failure?
      render status: :bad_request
    end
  end

  def fail
    @command = FailBuild.call(@build)
    if @command.failure?
      render status: :bad_request
    end
  end

  def success
    @command = SuccessBuild.call(@build)
    if @command.failure?
      render status: :bad_request
    end
  end

  def error
    @command = ErrorBuild.call(@build)
    if @command.failure?
      render status: :bad_request
    end
  end

  private

  def set_build
    @build = Build.find(builds_params)
  end

  def set_current_user_build
    @current_user_build = @current_user.builds.find(builds_params)
  end

  def builds_params
    params.require(:build).permit(:id, :project_id)
  end

  def project_id
    builds_params[:project_id]
  end
end
