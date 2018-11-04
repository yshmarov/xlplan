json.extract! employee, :id, :person_id, :location_id, :specialization, :employment_date, :termination_date, :status, :created_at, :updated_at
json.url employee_url(employee, format: :json)
