class Machine < ApplicationRecord
  belongs_to :location

  enum status: [:"Active", :"Inactive"]

  validates :name, uniqueness: true
  validates :name, :location_id, :status, presence: true

  def to_s
    name
  end

end
