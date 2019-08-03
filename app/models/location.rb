class Location < ApplicationRecord

  acts_as_tenant
  validates :name, length: { maximum: 50 }
  validates :phone_number, length: { maximum: 144 }
  validates :email, length: { maximum: 144 }
  validates :address, length: { maximum: 255 }
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  #serialize :address

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  extend FriendlyId
  friendly_id :to_s, use: :slugged

  has_many :members, dependent: :restrict_with_error
  has_many :events, dependent: :restrict_with_error
  has_many :jobs, through: :events

  validates_uniqueness_of :name, scope: :tenant_id
  validates :name, :balance, :status, presence: true

  enum status: { inactive: 0, active: 1 }
  #scope :active, -> { where(status: [:active]) }
  #scope :inactive, -> { where(status: [:inactive]) }
  def self.active_or_id(record_id)
    where('id = ? OR (status=1)', record_id)    
  end

  monetize :balance, as: :balance_cents

  after_touch :update_balance

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
        if tenant.locations.count > 4
          errors.add(:base, "Demo plan cannot have more than 5 locations. Upgrade your plan")
        end
      elsif tenant.plan == 'bronze'
        if tenant.locations.count > 0
          errors.add(:base, "Bronze plan cannot have more than 1 location. Upgrade your plan")
        end
      elsif tenant.plan == 'silver'
        if tenant.locations.count > 0
          errors.add(:base, "Silver plan cannot have more than 5 locations. Upgrade your plan")
        end
      #elsif tenant.plan == 'gold'
      end
    end
  end

  #protected

  def update_balance
    update_column :balance, (jobs.map(&:client_due_price).sum)
  end

end
