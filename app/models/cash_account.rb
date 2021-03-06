class CashAccount < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------callbacks-------------------#
  after_touch :update_balance
  #-----------------------relationships-------------------#
  has_many :transactions
  #-----------------------validation-------------------#
  validates :name, presence: true
  validates_uniqueness_of :name, scope: :tenant_id
  validates :slug, uniqueness: true
  validates :slug, uniqueness: {case_sensitive: false}
  #-----------------------gem money-------------------#
  monetize :balance, as: :balance_cents
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: proc { |controller, model| controller.current_user }
  tracked tenant_id: proc { Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :name, use: :slugged

  def to_s
    name.to_s
  end

  def full_name
    name.to_s + " (" + balance_cents.to_s + ")"
  end

  def update_balance
    update_column :balance, transactions.map(&:amount).sum
  end
end
