json.extract! inbound_payment, :id, :tenant_id, :event_id, :client_id, :amount, :payment_method, :created_at, :updated_at
json.url inbound_payment_url(inbound_payment, format: :json)
