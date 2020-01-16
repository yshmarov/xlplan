class Service < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------relationships-------------------#
  belongs_to :service_category, counter_cache: true
  has_many :jobs, dependent: :restrict_with_error
  has_many :events, through: :jobs
  has_many :leads, dependent: :restrict_with_error
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :name, use: :slugged
  #-----------------------validation-------------------#
  validates_uniqueness_of :name, scope: :tenant_id
  validates :name, length: { in: 1..144 }
  validates :name, :service_category_id, :duration, :client_price, :client_price_cents, :member_percent, :member_price, presence: true
  validates :duration, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100000,  only_integer: true }
  validates :member_percent, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100,  only_integer: true }
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  #-----------------------money gem-------------------#
  monetize :client_price, as: :client_price_cents
  monetize :member_price, as: :member_price_cents
  #-----------------------scopes-------------------#
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :online_booking, -> { where(online_booking: true) }
  def self.active_or_id(record_id)
    where('id = ? OR (active=true)', record_id)    
  end
  #-----------------------callbacks-------------------#
  after_save :update_member_price
  
  def to_s
    name
  end

  def full_name
    name.to_s+'/'+service_category.name.to_s+','+duration.to_s+'min'+'('+description.to_s+')'
  end

  def name_and_caregory
    name.to_s+'/'+service_category.name.to_s
  end

  def full_name_with_price
    name.to_s+'/'+service_category.name.to_s+'('+client_price_cents.to_i.to_s+'¤)'+','+duration.to_s+'min'
  end

  def name_price_duration_description
    name.to_s+
    '/'+
    client_price_cents.to_i.to_s+
    ''+
    Tenant.current_tenant.default_currency.to_s+
    '/'+
    duration.to_s+
    'min ('+
    description.to_s+
    ')'
  end

  private

  def update_member_price
    update_column :member_price, (client_price*member_percent/100)
  end
end