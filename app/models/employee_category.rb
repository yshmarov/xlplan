class EmployeeCategory < ApplicationRecord
  belongs_to :employee
  belongs_to :category
  validates :employee_id, :category_id, presence: true
  validates_uniqueness_of :category_id, :scope => :employee_id

end
