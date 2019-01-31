json.array! @events, partial: 'events/event', as: :event

//## json.array! @events do |event|
//##     json.id event.id
//##     json.title event.id
//##     json.start event.starts_at
//##     json.end event.ends_at
//##     json.color event.status_color unless event.status_color.blank?
//##     json.url event_url(event, format: :json)
//## end
