class Service < ApplicationRecord

  acts_as_tenant

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  extend FriendlyId
  friendly_id :full_name, use: :slugged

  belongs_to :service_category, counter_cache: true
  has_many :jobs, dependent: :restrict_with_error
  has_many :events, through: :jobs

  validates_uniqueness_of :name, scope: :tenant_id
  validates :name, length: { in: 1..144 }
  validates :description, length: { in: 0..144 }
  validates :name, :service_category, :duration, :client_price, :member_percent, :member_price, :status, presence: true
  validates :member_percent, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100,  only_integer: true }
  #class_attribute :client_price, default: {}

  monetize :client_price, as: :client_price_cents
  monetize :member_price, as: :member_price_cents

  enum status: { inactive: 0, active: 1 }

  after_create :update_member_price
  after_update :update_member_price
  after_save :update_member_price
  
  def to_s
    name
  end

  def full_name
    service_category.to_s+'/'+name.to_s+'('+description.to_s+')'+','+duration.to_s+'min'
  end

  def full_name_with_price
    #service_category.to_s+'/'+name.to_s+'('+description.to_s+')('+client_price_cents.to_i.to_s+'/'+member_price_cents.to_i.to_s+')'+','+duration.to_s+'min'
    service_category.to_s+'/'+name.to_s+'('+description.to_s+')('+client_price_cents.to_i.to_s+' '+Tenant.current_tenant.default_currency.to_s+')'+','+duration.to_s+'min'
  end

  private

  def update_member_price
    update_column :member_price, (client_price*member_percent/100)
  end

end
