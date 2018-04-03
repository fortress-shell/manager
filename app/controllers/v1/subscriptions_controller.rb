class V1::SubscriptionsController < ApplicationController
  def index
    @view_subscriptions = ViewSubscriptions.call(github_client)
    render status: :bad_request if @view_subscriptions.failure?
  end

  def create
    @create_subscription = CreateSubscription.call(github_client,
      @current_user,
      params[:id])
    render status: :bad_request if @create_subscription.failure?
  end

  def destroy
    @destroy_subscription = DestroySubscription.call(github_client, project)
    render status: :bad_request if @destroy_subscription.failure?
  end

  private

  def project
    @current_user.projects.find_by_repository_id!(params[:id])
  end

  def github_client
    Octokit::Client.new(access_token: @current_user.access_token,
      per_page: 500)
  end
end
