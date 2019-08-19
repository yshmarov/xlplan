# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview
  def client_event_created
    EventMailer.client_event_created(Event.last).deliver_now
  end
end
