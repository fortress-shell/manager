class CreateBuild
  prepend SimpleCommand

  def initialize(project, payload)
    @project = project
    @user = project.user
    @payload = payload
    @branch = payload[:ref].split('/').last
    @repository_id = project.repository_id
  end

  def call
    configuration = Base64.decode64(fortress_yml)
    options = {
      configuration: configuration,
      payload: @payload
    }
    spec = YAML.dump(configuration)
    filter = spec['general']['branches']['only']
    @build = @project.builds.create(options)
    if filter.include? @branch
      @build.skip!
      MessageBus.notify({
        user_id: @user.id,
        project_id: @project.id,
        status: @build.status,
        branch: @branch
      })
    else
      DispatchToNomad.call(@build)
      MessageBus.notify({
        user_id: @user.id,
        project_id: @project.id,
        status: @build.status,
        branch: @branch
      })
    end
  end

  private

  def fortress_yml
    @fortress_yml ||= github_client.contents(@repository_id,
      path: 'fortress.yml')['content']
  end

  def github_client
    @github_client ||= Octokit::Client.new(access_token: @user.access_token)
  end
end
