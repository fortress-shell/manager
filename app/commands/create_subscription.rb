class CreateSubscription
  prepend SimpleCommand
    def initialize(github_client, github_repository_id)
      @github_client = github_client
      @github_repository_id = github_repository_id
      @secret = SecureRandom.hex
      @key_pair = OpenSSL::PKey::RSA.new 2048
    end

    def call
      deploy_key = client.add_deploy_key(
        github_repository_id,
        DEPLOY_KEY,
        public_key
      )
      type = 'web'
      config = {
        url: 'http://webhoook.fortress.sh/webhook',
        content_type: 'json',
        secret: secret,
      }
      options = {
        :events => ['push'],
        :active => true
      }
      hook = @client.create_hook(
        github_repository_id,
        type,
        config,
        options
      )
      Project.create({
        private_key: @key_pair.to_pem,
        repo_id: github_repository_id,
        hook: hook,
        deploy_key: deploy_key,
        secret: secret,
      })
      end
    end

    private

    def public_key
      type = @key_pair.ssh_type
      data = [ @key_pair.to_blob ].pack('m0')
      "#{type} #{data}"
    end
  end
