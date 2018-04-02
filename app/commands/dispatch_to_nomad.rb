class DispatchToNomad
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
     meta = {
      build_id: @build.id,
      ssh_key: @build.project.deploy_key,
      username: @build.payload[:repository][:owner][:login],
      repository: @build.payload[:repository][:ssh_url],
      branch: @build.payload[:ref].split('/').last,
      commit: @build.payload[:after],
    }
    payload = Base64.encode(@build.configuration)
    result = NomadTask.dispatch(payload, meta)
    @build.update!(dispatched_job_id: result[:DispatchedJobID])
    @build.schedule!
  end
end
