json.array! @events do |event|

  json.id event.id
  json.title event.id
  json.start event.starts_at
  json.end event.ends_at
  json.url event_url(event)


  //## json.color event.status_color unless event.status_color.blank?
  //## json.url event_url(event, format: :json)
  //## json.update_url event_path(event, method: :patch)
  //## json.edit_url edit_event_path(event)

end
