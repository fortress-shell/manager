# RabbitMQ connection configuration

class MessageBus
  @@channels = Hash.new

  def self.notify(message)
    channel.publish(message.to_json)
  end

  def self.channel
    @@channels[Thread.current] ||= create_channel
  end

  def self.create_channel
    connection.create_channel.fanout('messages')
  end

  def self.connection
    @connection ||= Bunny.new.tap &:start
  end
end
