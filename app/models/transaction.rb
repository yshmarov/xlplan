class Transaction < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------relationships-------------------#
  belongs_to :payable, polymorphic: true, counter_cache: :transactions_count
  belongs_to :cash_account, touch: true, counter_cache: true
  #-----------------------validation-------------------#
  validates :amount, :amount_cents, :cash_account, :payable_id, :payable_type, presence: true
  validates :amount, :amount_cents, numericality: {greater_than: -10000000000, less_than: 10000000000}
  validates :slug, uniqueness: true
  validates :slug, uniqueness: {case_sensitive: false}
  #-----------------------gem money-------------------#
  monetize :amount, as: :amount_cents
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: proc { |controller, model| controller.current_user }
  tracked tenant_id: proc { Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :generated_slug, use: :slugged
  def generated_slug
    require "securerandom"
    @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  end

  def to_s
    slug
  end
  #-----------------------callbacks-------------------#
  after_save :update_payable_transactions_sum
  after_destroy :update_payable_transactions_sum
  def update_payable_transactions_sum
    if payable.present?
      payable.update_transactions_sum
    end
  end
end
