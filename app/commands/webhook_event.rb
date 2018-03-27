class WebhookEvent
   prepend SimpleCommand

  def initialize(params, github_signature)
    @params = params
    @repository_id = params[:repository][:id]
    @github_signature = github_signature
  end

  def call
    @project = Project.find(@repository_id)
    raw_payload = JSON.generate(@params)
    if verify_signature(raw_payload, @project.secret)
      create_build
      start_build
    else
      errors.add(:signature, 'Invalid signature!')
    end
  end

  private

  def create_build
    user = @project.user
    github_client = Octokit::Client.new(access_token: user.access_token)
    response = github_client.contents(@repository_id, :path => 'fortress.yml')
    configuration = Base64.decode64(response['content'])
    options = {
      configuration: configuration,
      payload: @params
    }
    @build = @project.builds.create(options)
  end

  def start_build
    if @project.user.plan.equal? @project.builds.running.length
      meta = {
        build_id: @build.id,
        ssh_key: @project.deploy_key,
        username: repository[:repository][:owner][:name],
        repository: repository[:repository][:ssh_url],
        branch: params[:ref].split('/').last,
        commit: params[:after],
      }
      result = NomadTask.dispatch(@build.configuration, meta)
      @build.update!(dispatched_job_id: result[:DispatchedJobID])
      @build.aasm.fire!(:run)
    else
      @build.aasm.fire!(:queue)
    end
  end

  def verify_signature(payload_body, secret)
    sha1 = OpenSSL::Digest.new('sha1');
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(sha1, secret, payload_body)
    Rack::Utils.secure_compare(github_signature, signature)
  end
end
