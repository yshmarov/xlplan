class InboundPayment < ApplicationRecord
  acts_as_tenant

  belongs_to :tenant
  belongs_to :client, touch: true, counter_cache: true
  belongs_to :payable, polymorphic: true

  validates :amount, :payment_method, presence: true
  validates :amount, :numericality => {:greater_than => -10000000000, :less_than => 10000000000}
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }

  monetize :amount, as: :amount_cents
  validates :client, :amount, :amount_cents, :payment_method, presence: true

  PAYMENT_METHODS = [:cash, :tip, :bank_transfer, :credit_card, :subscription_card, :certificate] 

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  extend FriendlyId
  friendly_id :generated_slug, use: :slugged
  def generated_slug
    require 'securerandom' 
    @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  end

  def to_s
    slug
  end
  
end