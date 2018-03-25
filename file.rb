require 'simple_command'

class AuthenticateUser
  # put SimpleCommand before the class' ancestors chain
  prepend SimpleCommand

  # optional, initialize the command with some arguments
  def initialize(user)
    @user = user
  end

  # mandatory: define a #call method. its return value will be available
  #            through #result
  def call
	  fuckme
   end 

   private 

      def fuckme

	  puts @user

      end
end

c = AuthenticateUser.call 'fuck'
puts c.result

