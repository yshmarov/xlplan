class InboundPayment < ApplicationRecord
  acts_as_tenant

  belongs_to :tenant
  belongs_to :event
  belongs_to :client

  validates :client, :event, :starts_at, :amount, :payment_method, presence: true
  validates :amount, :numericality => {:greater_than => -100000000, :less_than => 100000000}

  monetize :amount, as: :amount_cents

  PAYMENT_METHODS = [:cash, :credit_card, :bank_transfer, :subscription_card, :certificate, :barter, :gift, :free, :group_buying, :other] 

  def to_s
    id
  end
  
end