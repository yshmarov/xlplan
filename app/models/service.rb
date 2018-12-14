class Service < ApplicationRecord

  acts_as_tenant

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  belongs_to :service_category, counter_cache: true
  has_many :jobs, dependent: :restrict_with_error

  validates :name, uniqueness: true
  validates :name, length: { in: 1..144 }
  validates :description, length: { maximum: 255 }
  validates :name, :duration, :client_price, :member_percent, :member_price, :quantity, :status, :service_category, presence: true

  accepts_nested_attributes_for :service_category, :reject_if => :all_blank

  monetize :client_price, as: :client_price_cents
  monetize :member_price, as: :member_price_cents

  enum status: { inactive: 0, active: 1 }

  #after_update :update_member_price
  after_save :update_member_price
  
  def to_s
    name
  end

  def full_name
    name.to_s+'('+description.to_s+'/'+service_category.to_s+')'+','+duration.to_s+'min'
  end

  def full_name_with_price
    name.to_s+'('+description.to_s+'/'+service_category.to_s+')('+client_price_cents.to_i.to_s+'/'+member_price_cents.to_i.to_s+')'+','+duration.to_s+'min'
  end

  private

  def update_member_price
    update_column :member_price, (client_price*member_percent/100)
  end

end
