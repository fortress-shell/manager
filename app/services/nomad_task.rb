class NomadTask
  include HTTParty
  base_uri ENV.fetch('NOMAD_URL')

  def self.dispatch(payload, meta)
    @options = {
      body: {
        Payload: Base64.encode64(payload),
        Meta: meta
      }.to_json,
      headers: {
        'Content-Type' => 'application/json'
      }
    }
    self.class.post("/v1/job/main-task/dispatch", @options)
  end
end
