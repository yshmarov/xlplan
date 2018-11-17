class ServiceCategory < ApplicationRecord

  has_many :services
  has_many :employee_service_categories
  has_many :employees, through: :employee_service_categories

  validates :name, uniqueness: true
  validates :name, presence: true

  def to_s
    name
  end

end
