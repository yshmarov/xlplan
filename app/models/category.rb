class Category < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, presence: true
  def to_s
    name
  end

end
