json.extract! event, :id, :client_id, :start, :status, :service_id, :location_id, :employee_id, :service_name, :service_description, :service_duration, :client_price, :employee_price, :created_at, :updated_at
json.url event_url(event, format: :json)
