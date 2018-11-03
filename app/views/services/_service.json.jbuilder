json.extract! service, :id, :name, :description, :duration, :client_price, :employee_percent, :employee_price, :quantity, :status, :created_at, :updated_at
json.url service_url(service, format: :json)
