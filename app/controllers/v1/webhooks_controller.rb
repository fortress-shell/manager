class V1::WebhooksController < ApplicationController
  skip_before_action :authorize_user!
  skip_before_action :verify_authenticity_token
  include GithubWebhook::Processor

  def github_push(payload)
    CreateBuild.call(@project, payload)
  end

  private

  def webhook_secret(payload)
    @project = Project.find_by_repository_id(payload[:repository][:id])
    @project.webhook_secret
  end
end
