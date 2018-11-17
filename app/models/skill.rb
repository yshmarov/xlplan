class Skill < ApplicationRecord
  belongs_to :employee
  belongs_to :service_category
  validates :employee_id, :service_category_id, presence: true
  validates_uniqueness_of :service_category_id, :scope => :employee_id
end
