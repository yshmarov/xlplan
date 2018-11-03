json.extract! person, :id, :first_name, :middle_name, :last_name, :date_of_birth, :sex, :email, :phone_number, :address, :description, :status, :created_at, :updated_at
json.url person_url(person, format: :json)
