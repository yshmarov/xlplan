# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview
  def client_event_created
    #EventMailer.client_event_created(Event.last).deliver_now
    #finds first event that has a client
    EventMailer.client_event_created(Event.joins(:client).where.not(clients: {email: [nil, ""]}).first).deliver_now
  end
end
