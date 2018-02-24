require 'singleton'

class Notifier
  include Singleton
  def initialize
    puts 'new'
    @@bunny = Object.new
  end
  def publish(message)
    puts @@bunny
  end
  def self.connection
    puts 'connection'
  end
  at_exit do
    puts @@bunny
  end
end


Notifier.instance.publish 'fuck'
Notifier.instance.publish 'fuck'
