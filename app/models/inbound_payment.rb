class InboundPayment < ApplicationRecord
  acts_as_tenant

  belongs_to :tenant
  belongs_to :client, touch: true, counter_cache: true

  #validates :client, :event
  validates :amount, :payment_method, presence: true
  validates :amount, :numericality => {:greater_than => -100000000, :less_than => 100000000}

  monetize :amount, as: :amount_cents
  validates :client, :amount, :amount_cents, :payment_method, presence: true

  PAYMENT_METHODS = [:cash, :tip, :bank_transfer, :credit_card, :subscription_card, :certificate, :barter, :gift, :free, :other] 

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }

  def to_s
    id
  end
  
end