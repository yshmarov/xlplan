json.extract! location, :id, :name, :tel, :email, :address, :balance, :status, :created_at, :updated_at
json.url location_url(location, format: :json)
