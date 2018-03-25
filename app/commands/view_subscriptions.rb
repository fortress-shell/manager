class DestroySubscription
  prepend SimpleCommand

  def initialize(github_client)
    @github_client = github_client
  end

  def call
    @github_client.repositories.map do |repository|
      subscribed = @github_client.hooks(repository[:id]).find { |hook|
        hook[:name] = 'Fortress Shell'
      }
      repository[:subscribed] = subscribed
      repository
    end
  end

  private

  def webhook_id
    project.webhook.id
  end

  def deploy_key_id
    project.deploy_key.id
  end
end
