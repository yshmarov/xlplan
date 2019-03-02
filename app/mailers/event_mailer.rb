class EventMailer < ApplicationMailer
  default from: 'support@xlplan.com'
  #default to: -> { Admin.pluck(:email) }, from: 'notification@example.com'

  def welcome_email(user)
    @greeting = "Hi"
    @user = user
  end

  def welcome_email_actionmailer
    @user = params[:user]
    @url  = 'http://xlplan.com/login'
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
