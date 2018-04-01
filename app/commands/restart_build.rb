class RestartBuild
  prepend SimpleCommand

  def initialize(build, user, project)
    @build = build
    @user = user
    @project = project
  end

  def call
    @build = @project.builds.create(configuration: @build.configuration,
        payload: @build.payload)
    elsif @user.plan.equal? @project.builds.running.count
      @build.dispatch_to_nomad
      MessageBus.notify({
        })
    else
      @build.queue!
      MessageBus.notify({
        })
    end
  end

  private
end
