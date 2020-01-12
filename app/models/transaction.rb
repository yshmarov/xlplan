class Transaction < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------relationships-------------------#
  belongs_to :payable, polymorphic: true
  belongs_to :cash_account, touch: true, counter_cache: true
  #-----------------------validation-------------------#
  validates :amount, :amount_cents, :category, :cash_account, :payable_id, :payable_type, presence: true
  validates :amount, :amount_cents, :numericality => {:greater_than => -10000000000, :less_than => 10000000000}
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  #-----------------------gem money-------------------#
  monetize :amount, as: :amount_cents
  #-----------------------category options--------------------------------#
  CATEGORIES = [:client_balance, :client_event, :expence_salary, :expence_rent, :expence_other, :from_acc, :to_acc]
  def self.categories
    CATEGORIES.map {|category| [I18n.t(category, scope: [:activerecord, :attributes, :transaction, :categories]).capitalize, category]}
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

  after_save :update_client_payments_balance
  after_destroy :update_client_payments_balance
  def update_client_payments_balance
    payable.update_payments_balance
  end
end