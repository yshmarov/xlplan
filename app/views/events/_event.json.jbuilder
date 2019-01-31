//## json.extract! event, :id, :tenant_id, :client_id, :location_id, :starts_at, :ends_at, :status, :notes, :status_color, :created_at, :updated_at
//## json.url event_url(event, format: :json)

json.id event.id
json.title event.id
json.start event.starts_at
json.end event.ends_at
json.color event.status_color unless event.status_color.blank?
json.url event_url(event, format: :json)
