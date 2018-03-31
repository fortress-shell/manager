class DestroySubscription
  prepend SimpleCommand

  def initialize(github_client, project)
    @github_client = github_client
    @project = project
  end

  def call
    @github_client.remove_hook(repository_id, webhook_id)
    @github_client.remove_deploy_key(repository_id, deploy_key_id)
    @project.destroy
  end

  private

  def repository_id
    @project.repository_id
  end

  def webhook_id
    @project.webhook['id']
  end

  def deploy_key_id
    @project.deploy_key['id']
  end
end
