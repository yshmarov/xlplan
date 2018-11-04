class Employee < ApplicationRecord
  belongs_to :person
  belongs_to :location

  validates :person_id, :location_id, :status, presence: true
  validates :person_id, uniqueness: true

  def to_s
    person
  end

  enum status: [:"Active", :"Inactive"]

end
