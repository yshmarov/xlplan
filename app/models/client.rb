class Client < ApplicationRecord
  belongs_to :person
  belongs_to :employee

  validates :person_id, :employee_id, :status, presence: true
  validates :person_id, uniqueness: true

  def to_s
    person
  end

  enum status: [:"Active", :"Inactive"]

end
