class CreateBuild
  prepend SimpleCommand

  def initialize(project, payload)
    @project = project
    @user = project.user
    @payload = payload
    @repository_id = project.repository_id
  end

  def call
    configuration = Base64.decode64(fortress_yml)
    options = {
      configuration: configuration,
      payload: @payload
    }
    # spec = YAML.dump(configuration)
    # filter = spec['general']['branches']
    # @build = @project.builds.create(options)
    # if filter.include? @payload[:ref].split('/').last
    #   @build.skip!
    # elsif @user.plan.equal? @project.builds.running.count
    #   # meta = {
    #   #   build_id: @build.id,
    #   #   ssh_key: @project.deploy_key,
    #   #   username: @payload[:repository][:owner][:login],
    #   #   repository: @payload[:repository][:ssh_url],
    #   #   branch: @payload[:ref].split('/').last,
    #   #   commit: @payload[:after],
    #   # }
    #   # result = NomadTask.dispatch(fortress_yml, meta)
    #   # @build.update!(dispatched_job_id: result[:DispatchedJobID])
    # else
    #   @build.queue!
    # end
    MessageBus.notify(options)
  end

  private

  def fortress_yml
    @fortress_yml ||= github_client.contents(@repository_id,
      :path => 'fortress.yml')['content']
  end

  def github_client
    @github_client ||= Octokit::Client.new(access_token: @user.access_token)
  end
end
