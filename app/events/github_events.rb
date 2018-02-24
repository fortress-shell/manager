class GithubEvents
  def initialize instance
    @instance = instance
  end

  def fire_event
    ch = conn.create_threaded_channel
    q = ch.queue("message")
    q.publish("Hello!", :routing_key => "1")
  end
end
