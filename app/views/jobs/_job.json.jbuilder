json.extract! job, :id, :client_id, :starts_at, :ends_at, :status, :service_id, :location_id, :employee_id, :service_name, :service_description, :service_duration, :client_price, :employee_price, :created_at, :updated_at
json.url job_url(job, format: :json)
