class InboundPayment < ApplicationRecord
  acts_as_tenant

  belongs_to :tenant
  belongs_to :event
  belongs_to :client

  validates :client, :location, :starts_at, :duration, :ends_at, :status, :status_color, :client_price, presence: true

end
