class ServiceCategory < ApplicationRecord

  acts_as_tenant

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  has_many :services
  has_many :skills
  has_many :employees, through: :skills

  validates :name, uniqueness: true
  validates :name, presence: true
  validates :name, length: { maximum: 144 }

  #validate :free_plan_can_only_have_one
  #def free_plan_can_only_have_one
  #  if self.new_record? && (tenant.service_categories.count > 0) && (tenant.plan == 'free')
  #    errors.add(:base, "Free plans cannot have more than one service_category")
  #  end
  #end

  def to_s
    name
  end

end
