class ViewSubscriptions
  prepend SimpleCommand

  def initialize(github_client)
    @github_client = github_client
  end

  def call
    repositories = @github_client.repositories(nil)
    repository_ids = repositories.map { |r| r[:id] }
    projects = Project.where(repository_id: repository_ids).ids
    puts 'blabla', repositories.size
    repositories.each do |r|
      r[:subscribed] = projects.include? r[:id]
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
