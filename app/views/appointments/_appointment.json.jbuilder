json.extract! appointment, :id, :tenant_id, :client_id, :member_id, :location_id, :starts_at, :ends_at, :status, :description, :status_color, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
