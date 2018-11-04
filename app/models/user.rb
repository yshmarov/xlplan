class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :invitable, :validate_on_invite => true

  belongs_to :person

  validates :person_id, presence: true
  validates :person_id, uniqueness: true

  def to_s
    email
  end
end
