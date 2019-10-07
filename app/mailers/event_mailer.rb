class EventMailer < ApplicationMailer
  #default to: -> { Admin.pluck(:email) }, from: 'notification@example.com'

  def client_event_created(event)
    @event = event

    event_start = @event.starts_at.strftime("%Y%m%dT%H%M%S%Z")
    event_end = @event.ends_at.strftime("%Y%m%dT%H%M%S%Z")
    @location = "#{@event.location.name}, #{@event.location.address_line}"

    @summary = "#{@event.services.pluck(:name).join(', ')} (#{Tenant.current_tenant.name})"
    @description = "#{@event.services.pluck(:name).join(', ')}.
                    #{Tenant.current_tenant.name},
                    #{@event.location.name},
                    #{@event.location.phone_number},
                    #{@event.location.address_line}. 
                    Powered by XLPLAN https://www.xlplan.com"

    #@organiser = @event.members.distinct.pluck(:email)
    @organiser = "mailto:#{@event.users.pluck(:email)}"
    #@attendee = %w(mailto:abc@example.com mailto:xyz@example.com)
    #@attendee = %w(mailto: #{@event.client.email})

    ical = Icalendar::Calendar.new
    e = Icalendar::Event.new    
    e.dtstart = Icalendar::Values::DateTime.new event_start
    e.dtend   = Icalendar::Values::DateTime.new event_end
    e.location = @location      
    e.summary = @summary   
    e.description = @description

    e.organizer = @organiser
    e.organizer = Icalendar::Values::CalAddress.new(@organiser, cn: 'Office Manager')
    #e.attendee  = @attendee   

    ical.add_event(e)    
    ical.append_custom_property('METHOD', 'REQUEST')
    #mail.attachments['slackminder.ics'] = { mime_type: 'application/ics', content: ical.to_ical }
    mail.attachments['booking.ics'] = { :mime_type => 'text/calendar', content: ical.to_ical }
    mail(to: @event.client.email, subject: 'Booking created in XLPLAN.com')
  end

  def member_event_created(event)
    @event = event
    mail(to: @event.users.distinct.pluck(:email), subject: 'Booking created in XLPLAN.com')
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
