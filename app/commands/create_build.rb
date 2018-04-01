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
    spec = YAML.dump(configuration)
    filter = spec['general']['branches']
    @build = @project.builds.create(options)
    MessageBus.notify({

      })
    if filter.include? @payload[:ref].split('/').last
      @build.skip!
      MessageBus.notify({

        })
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

  def fortress_yml
    @fortress_yml ||= github_client.contents(@repository_id,
      :path => 'fortress.yml')['content']
  end

  def github_client
    @github_client ||= Octokit::Client.new(access_token: @user.access_token)
  end
end
