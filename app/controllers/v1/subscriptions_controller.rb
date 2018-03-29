class V1::SubscriptionsController < ApplicationController
  def index
    @command = ViewSubscriptions.call(github_client)
    if @command.failure?
      render status: :bad_request
    end
  end

  def create
    @command = CreateSubscription.call(github_client, github_repository_id)
    if @command.failure?
      render status: :bad_request
    end
  end

  def destroy
    @command = DestroySubscription.call(github_client, project)
    if @command.failure?
      render status: :bad_request
    end
  end

  private

  def github_repository_id
    params.require(:id)
  end

  def project
    Project.find_by_repository_id(github_repository_id)
  end

  def github_client
    Octokit::Client.new(access_token: @current_user.access_token,
      per_page: 500)
  end
end
