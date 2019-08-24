# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview
  def client_event_created
    #EventMailer.client_event_created(Event.last).deliver_now
    #finds first event that has a client
    #event_with_client_email = Event.joins(:client).where.not(clients: {email: [nil, ""]}).first
    #event_without_client_email
    EventMailer.client_event_created(Event.joins(:client).where.not(clients: {email: [nil, ""]}).first).deliver_now
  end

  def member_event_created
    EventMailer.member_event_created(Event.first).deliver_now
  end

end