class DispatchToNomad
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    meta = {
      build_id: @build.id.to_s,
      user_id: @build.user.id.to_s,
      ssh_key: @build.project.private_key,
      repository_url: @build.payload['repository']['ssh_url'],
      branch: @build.payload['ref'].split('/').last,
      commit: @build.payload['after'],
    }
    result = NomadTask.dispatch(@build.configuration, meta)
    @build.update!(dispatched_job_id: result['DispatchedJobID'])
    @build.schedule!
    @build
  end
end
