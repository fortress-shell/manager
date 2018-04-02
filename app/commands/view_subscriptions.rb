class ViewSubscriptions
  prepend SimpleCommand

  def initialize(github_client)
    @github_client = github_client
  end

  def call
    repositories = @github_client.repositories(nil)
    ids = repositories.map { |r| r[:id] }
    projects = Project.where(repository_id: ids)
      .pluck(:repository_id)
    repositories.each { |r| r[:subscribed] = projects.include? r[:id] }
  end
end
