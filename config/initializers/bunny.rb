# RabbitMQ connection configuration

class MessageBus
  @@channels = Hash.new

  def self.publish(message)
    exchange.publish(message.to_json)
  end

  def self.exchange
    @@channels[Thread.current] ||= connection.create_channel.direct('messages')
  end

  def self.connection
    @connection ||= Bunny.new.tap &:start
  end
end
