json.extract! expence, :id, :tenant_id, :amount, :payment_method, :expendable_type, :expendable_id, :slug, :created_at, :updated_at
json.url expence_url(expence, format: :json)
