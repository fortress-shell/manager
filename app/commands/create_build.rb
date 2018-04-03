class CreateBuild
  prepend SimpleCommand

  def initialize(project, payload)
    @project = project
    @user = project.user
    @payload = payload
    @commit = payload[:after]
    @branch = payload[:ref].split('/').last
    @repository_id = project.repository_id
  end

  def call
    options = {
      configuration: plain_fortress_yml,
      payload: @payload
    }
    @build = @project.builds.create(options)
    DispatchToNomad.call(@build)
    MessageBus.notify({
      user_id: @user.id,
      project_id: @project.id,
      id: @build.id,
      commit: @commit,
      created_at: @build.created_at,
      status: @build.status,
      branch: @branch
    })
  end

  private

  def plain_fortress_yml
    @plain_fortress_yml ||= Base64.decode64(base64_fortress_yml)
  end

  def base64_fortress_yml
    @base64_fortress_yml ||= github_client.contents(@repository_id,
      path: 'fortress.yml',
      ref: @commit)['content']
  end

  def github_client
    @github_client ||= Octokit::Client.new(access_token: @user.access_token)
  end
end
