class DestroySubscription
  prepend SimpleCommand

  def initialize(github_client, github_repository_id, project)
    @github_client = github_client
    @github_repository_id = github_repository_id
    @project = project
  end

  def call
    puts "fuck'"
    # @github_client.remove_hook(github_repository_id, webhook_id)
    # @github_client.remove_deploy_key(github_repository_id, deploy_key_id)
    # @project.destroy
  end

  private

  def webhook_id
    project.webhook['id']
  end

  def deploy_key_id
    project.deploy_key['id']
  end
end
