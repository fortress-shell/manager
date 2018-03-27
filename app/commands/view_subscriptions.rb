class ViewSubscription
  prepend SimpleCommand

  def initialize(github_client)
    @github_client = github_client
  end

  def call
    @github_client.repositories(nil).each do |repo|
      repo[:subscribed] = has_fortress_shell_hook repo[:id]
    end
  end

  private

  def has_fortress_shell_hook(repository_id)
    @github_client.hooks(repository_id)
      .map(&:name)
      .include?(Rails.application.secrets.project_name)
  end

  def webhook_id
    project.webhook.id
  end

  def deploy_key_id
    project.deploy_key.id
  end
end
