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
  has_many :leads, dependent: :restrict_with_error
  has_many :operating_hours, inverse_of: :location, dependent: :destroy
  accepts_nested_attributes_for :operating_hours, reject_if: :all_blank, allow_destroy: true
  #-----------------------validation-------------------#
  validates_uniqueness_of :name, scope: :tenant_id
  validates :name, :balance, presence: true
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
  #-----------------------scopes-------------------#
  #def open?  #for operating_hours
  #  operating_hours.where("? BETWEEN opens AND closes", Time.zone.now).any?
  #end
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :online_booking, -> { where(online_booking: true) }
  def self.active_or_id(record_id)
    where('id = ? OR (active=true)', record_id)    
  end
  #-----------------------money gem-------------------#
  monetize :balance, as: :balance_cents
  monetize :payments_amount_sum, as: :payments_amount_sum_cents

  def to_s
    if name.present?
      name
    else
      id
    end
  end
  
  def name_and_address
    to_s + " (" + address_line + ")"
  end

  ################TENANT VALIDATION#################
  validate :tenant_plan_quantity_limit
  def tenant_plan_quantity_limit
    if self.new_record?
      if tenant.plan == 'bronze'
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
    update_column :payments_amount_sum, (events.map(&:event_due_price).sum)
    update_column :balance, (payments_amount_sum)
  end

end
