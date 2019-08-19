class EventMailer < ApplicationMailer
  #default to: -> { Admin.pluck(:email) }, from: 'notification@example.com'

  def client_event_created(event)
    @event = event
    mail(to: @event.client.email, subject: 'Booking created in XLPLAN.com')
    #mail(to: "yshmarov@gmail.com", subject: 'Booking created in XLPLAN.com')
  end

  def member_event_created(event)
    @event = event
    mail(to: @event.members.pluck(:email), subject: 'Booking created in XLPLAN.com')
  end

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to XLPLAN.com')
    #@greeting = "Hi"
  end

  def welcome_email_actionmailer
    @user = params[:user]
    @url  = 'http://xlplan.com/login'
    @greeting = "Hi Bro!"
    #mail to: user.email, subject: "Sign Up Confirmation"
    #mail(to: @user.email, subject: 'Welcome to My Awesome Site')
    #email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: User.with_role(:admin).pluck(:email), subject: 'Welcome to My Awesome Site')
  end

  def new_registration(user)
    @user = user
    mail(subject: "New User Signup: #{@user.email}")
  end

  def event_created
    #@user = params[:user]
    mail(to: "yshmarov@gmail.com", subject: 'Event created')
  end
end
