class Skill < ApplicationRecord

  acts_as_tenant

  belongs_to :member
  belongs_to :service_category
  validates :member_id, :service_category_id, presence: true
  validates_uniqueness_of :service_category_id, :scope => :member_id

end
