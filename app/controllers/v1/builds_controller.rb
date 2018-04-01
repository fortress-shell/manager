class V1::BuildsController < ApplicationController
  not_for_rpc = [:index, :show, :restart, :cancel]
  skip_before_action :authorize_user, except: not_for_rpc
  before_action :set_rpc_build, except: not_for_rpc

  def index
    @builds = @current_user.builds.find_by_project_id project_id
  end

  def show
    @build = @current_user.builds.find(params.require(:id))
  end

  def restart
    @command = RestartBuild.call(current_user_build)
    if @command.failure?
      render status: :bad_request
    end
  end

  def cancel
    @command = CancelBuild.call(current_user_build)
    if @command.failure?
      render status: :bad_request
    end
  end

  # rpc calls
  def stoped
    @build.cancel!
  end

  def start
    @build.run!
  end

  def timeout
    @build.timeout!
  end

  def fail
    @build.fail!
  end

  def success
    @build.success!
  end

  def maintenance
    @build.maintenance!
  end

  private

  def set_rpc_build
    @build = Build.find_by_dispatched_job_id dispatched_job_id
  end

  def dispatched_job_id
    rpc_build_params[:dispatched_job_id]
  end

  def rpc_build_params
    params.require(:event).permit(:dispatched_job_id)
  end

  def current_user_build
    @current_user.builds.find(build_params)
  end

  def build_params
    params.permit(:id, :project_id)
  end

  def project_id
    params.require(:project_id)
  end
end
