class InboundPayment < ApplicationRecord
  acts_as_tenant

  belongs_to :tenant
  belongs_to :event
  belongs_to :client

  validates :client, :event, :starts_at, :amount, :payment_method, presence: true

end
