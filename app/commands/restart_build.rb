class RestartBuild
  prepend SimpleCommand

  def initialize(build, user, project)
    @build = build
    @user = user
    @project = project
  end

  def call
    # create new build + check qos + update state to
    # queued and dispatch task to nomad if qos not limited
    @build = @project.builds.create(configuration: @build.configuration,
        payload: @build.payload)
    @build.schedule!
    DispatchToNomad.call(@build)
  end
end
