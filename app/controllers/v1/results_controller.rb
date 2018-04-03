class V1::ResultsController < ApplicationController
  skip_before_action :authorize_user!
  before_action :set_build
  include NomadWebhook::Processor

  def nomad_started
    @build_command = StartBuild.call(@build)
  end

  def nomad_terminated
    @build_command = case exit_code
    when 0 then SuccessBuild.call(@build)
    when 1 then FailBuild.call(@build)
    when 2 then TimeoutBuild.call(@build)
    when 4 then MaintenanceBuild.call(@build)
    else NopBuild.call
    end
  end

  def nomad_killed
    @build_command = StopBuild.call(@build)
  end

  private

  def exit_code
    params[:TaskEvent][:ExitCode]
  end

  def set_build
    @build = Build.find_by_dispatched_job_id!(params[:JobID])
  end
end
