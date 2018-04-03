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
    when 3...65535 then MaintenanceBuild.call(@build)
    end
  end

  private

  def exit_code
    params[:TaskEvent][:ExitCode]
  end

  def set_build
    @build = Build.find_by_dispatched_job_id!(params[:JobID])
  end
end
