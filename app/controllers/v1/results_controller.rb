class V1::ResultsController < ApplicationController
  skip_before_action :authorize_user!
  before_action :set_build

  def stoped
    @stop_build = StopBuild.call(@build)
    render status: :bad_request if @stop_build.failure?
  end

  def start
    @start_build = StartBuild.call(@build)
    render status: :bad_request if @start_build.failure?
  end

  def timeout
    @timeout_build = TimeoutBuild.call(@build)
    render status: :bad_request if @timeout_build.failure?
  end

  def fail
    @fail_build = FailBuild.call(@build)
    render status: :bad_request if @fail_build.failure?
  end

  def success
    @success_build = SuccessBuild.call(@build)
    render status: :bad_request if @success_build.failure?
  end

  def maintenance
    @maintenance_build = MaintenanceBuild.call(@build)
    render status: :bad_request if @maintenance_build.failure?
  end

  private

  def set_build
    @build = Build.find_by_dispatched_job_id(params[:JobID])
  end
end
