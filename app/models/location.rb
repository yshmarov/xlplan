class Location < ApplicationRecord

  acts_as_tenant
  validates :name, length: { maximum: 50 }
  validates :tel, length: { maximum: 144 }
  validates :email, length: { maximum: 144 }
  validates :address, length: { maximum: 255 }

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  has_many :members, dependent: :restrict_with_error
  has_many :jobs, dependent: :restrict_with_error

  #validates :name, uniqueness: true
  validates_uniqueness_of :name, :scope => :tenant_id

  validates :name, :balance, :status, presence: true

  enum status: { inactive: 0, active: 1 }

  monetize :balance, as: :balance_cents

  after_touch :update_balance

  def to_s
    name
  end

  def associations?
    jobs.any? || members.any?
  end

  validate :free_plan_can_only_have_one_location
  def free_plan_can_only_have_one_location
    if self.new_record? && (tenant.locations.count > 0) && (tenant.plan == 'free')
      errors.add(:base, "Free plans cannot have more than one location")
    end
  end

  #protected

  def update_balance
    update_column :balance, (jobs.map(&:client_due_price).sum)
  end

end
