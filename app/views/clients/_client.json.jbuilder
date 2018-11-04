json.extract! client, :id, :person_id, :employee_id, :balance, :status, :created_at, :updated_at
json.url client_url(client, format: :json)
