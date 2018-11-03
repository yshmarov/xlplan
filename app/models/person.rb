class Person < ApplicationRecord
  has_one :user

  validates :first_name, :last_name, :status, presence: true

  enum status: [:"Active", :"Inactive"]

  def to_s
    last_name.capitalize + " " + first_name.capitalize
  end

end