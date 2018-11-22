class ServiceCategory < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  has_many :services
  has_many :skills
  has_many :employees, through: :skills

  validates :name, uniqueness: true
  validates :name, presence: true

  def to_s
    name
  end

end
