class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email
    mail(to: 'luboworiz@20boxme.org', subject: 'Welcome to My Awesome Site')
  end
end
