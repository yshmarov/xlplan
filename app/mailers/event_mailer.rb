class EventMailer < ApplicationMailer
  default from: 'mrjobber@event_mailer.com'
 
  def welcome_email(user)
    @greeting = "Hi"
    @user = user
    #@user = params[:user]
    @url  = 'http://mrjobber.com/login'
    mail(to: @client.email, subject: 'Welcome to My Awesome Site')
  end

  def event_created
    mail(to: "yshmarov@gmail.com", subject: 'Event created')
  end

end
