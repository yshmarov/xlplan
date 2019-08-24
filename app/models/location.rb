class Location < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------callbacks-------------------#
  after_touch :update_balance
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  #-----------------------relationships-------------------#
  has_many :members, dependent: :restrict_with_error
  has_many :events, dependent: :restrict_with_error
  has_many :jobs, through: :events
  #-----------------------validation-------------------#
  validates_uniqueness_of :name, scope: :tenant_id
  validates :name, :balance, :status, presence: true
  validates :name, length: { maximum: 50 }
  validates :phone_number, length: { maximum: 144 }
  validates :email, length: { maximum: 144 }
  validates :address, length: { maximum: 255 }
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  #-----------------------serialization-------------------#
  serialize :address
  def address_line
    if address.present?
      [address[:country], address[:city], address[:street], address[:zip]].join(', ')
    end
  end
  #-----------------------enums-------------------#
  enum status: { inactive: 0, active: 1 }
  #-----------------------scopes-------------------#
  #scope :active, -> { where(status: [:active]) }
  #scope :inactive, -> { where(status: [:inactive]) }
  def self.active_or_id(record_id)
    where('id = ? OR (status=1)', record_id)    
  end
  #-----------------------money gem-------------------#
  monetize :balance, as: :balance_cents
  monetize :events_amount_sum, as: :events_amount_sum_cents

  def to_s
    if name.present?
      name
    else
      id
    end
  end

  ################TENANT VALIDATION#################
  validate :tenant_plan_quantity_limit
  def tenant_plan_quantity_limit
    if self.new_record?
      if tenant.plan == 'demo'
        if tenant.locations.count > 5
          errors.add(:base, "Demo plan cannot have more than 5 locations. Upgrade your plan")
        end
      elsif tenant.plan == 'bronze'
        if tenant.locations.count > 0
          errors.add(:base, "Bronze plan cannot have more than 1 location. Upgrade your plan")
        end
      elsif tenant.plan == 'silver'
        if tenant.locations.count > 5
          errors.add(:base, "Silver plan cannot have more than 5 locations. Upgrade your plan")
        end
      #elsif tenant.plan == 'gold'
      end
    end
  end

  #protected

  def update_balance
    update_column :events_amount_sum, (events.map(&:event_due_price).sum)
    update_column :balance, (events_amount_sum)
  end

end
