class Person < ApplicationRecord
  #has_one :user, inverse_of: :member
  scope :has_account, -> { includes(:users).where.not(users: {person_id: nil}) }
  has_one :user

  validates :first_name, :last_name, :status, presence: true
  validates :email, uniqueness: true

  enum status: [:"Active", :"Inactive"]

  def to_s
    last_name.capitalize + " " + first_name.capitalize
  end

end