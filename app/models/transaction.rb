class Transaction < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------relationships-------------------#
  belongs_to :client, touch: true, counter_cache: true
  belongs_to :payable, polymorphic: true
  #-----------------------validation-------------------#
  #validates :amount, :payment_method, presence: true
  validates :client, :amount, :amount_cents, :payment_method, :type, presence: true
  validates :amount, :amount_cents, :numericality => {:greater_than => -10000000000, :less_than => 10000000000}
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  #-----------------------gem money-------------------#
  monetize :amount, as: :amount_cents
  #-----------------------type options--------------------------------#
  TYPES = [:from_acc, :to_acc, :client_balance, :client_event, :expence_salary, :expence_rent, :expence_other, :withdraw]
  def self.types
    TYPES.map {|type| [I18n.t(type, scope: [:activerecord, :attributes, :transaction, :types]).capitalize, type]}
  end
  #-----------------------payment_method options--------------------------------#
  PAYMENT_METHODS = [:cash, :credit_card] 
  def self.payment_methods
    PAYMENT_METHODS.map {|payment_method| [I18n.t(payment_method, scope: [:activerecord, :attributes, :transaction, :payment_methods]).capitalize, payment_method]}
  end
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
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