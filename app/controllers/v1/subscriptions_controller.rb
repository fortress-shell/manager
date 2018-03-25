class V1::SubscriptionsController < ApplicationController
  before_action :set_github_client
  before_action :set_project, only: :destroy

  DEPLOY_KEY = 'Fortress Shell'

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
    @command = DestroySubscription.call(github_client, @project)
    if @command.failure?
      render status: :bad_request
    end
  end

  private

  def subscriptions_params
    params.require(:repository).permit(:id)
  end

  def github_repository_id
    subscriptions_params[:id]
  end

  def set_project
    @project = Project.find_by_repository_id(github_repository_id)
  end

  def github_client
    Octokit::Client.new(access_token: @current_user.access_token)
  end
end
