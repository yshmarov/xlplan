class Category < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, presence: true

  has_many :services

  def to_s
    name
  end

end
