class StopJobOnNomad
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    NomadTask.stop(@build.dispatched_job_id)
  end
end
