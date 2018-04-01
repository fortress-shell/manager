require 'net/ssh'

class CreateSubscription
  prepend SimpleCommand

  def initialize(github_client, current_user, github_repository_id)
    @github_client = github_client
    @current_user = current_user
    @github_repository_id = github_repository_id
    @secret = SecureRandom.hex
    @key_pair = OpenSSL::PKey::RSA.new 2048
  end

  def call
    deploy_key = @github_client.add_deploy_key(
      @github_repository_id,
      Rails.application.secrets.project_name,
      public_key
    )
    config = {
      url: 'http://a3096db2.ngrok.io/v1/webhooks',
      content_type: 'json',
      secret: @secret,
    }
    options = {
      :events => ['push'],
      :active => true
    }
    webhook = @github_client.create_hook(
      @github_repository_id,
      'web',
      config,
      options
    )
    repository = @github_client.repository(@github_repository_id)
    @current_user.projects.create!({
      private_key: @key_pair.to_pem,
      repository: repository.to_h,
      repository_id: repository[:id],
      repository_name: repository[:name],
      repository_owner: repository[:owner][:login],
      webhook: webhook.to_h,
      deploy_key: deploy_key.to_h,
      webhook_secret: @secret,
    })
  end

  private

  def public_key
    type = @key_pair.ssh_type
    data = [ @key_pair.to_blob ].pack('m0')
    "#{type} #{data}"
  end
end
