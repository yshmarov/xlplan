class ServiceCategory < ApplicationRecord

  has_many :services
  has_many :skills
  has_many :employees, through: :skills

  validates :name, uniqueness: true
  validates :name, presence: true

  def to_s
    name
  end

end
