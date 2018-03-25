class V1::WebhooksController < ApplicationController
  def index
    command = WebhookEvent.call(params, signature)
    if command.success?
      head :ok
    else
      head :bad_request
    end
  end

  private

  def signature
    request.headers['X-Hub-Signature']
  end
end

