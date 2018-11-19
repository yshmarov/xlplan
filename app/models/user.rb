class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :invitable, :validate_on_invite => true

  belongs_to :employee
  belongs_to :invitor, class_name: 'Employee', foreign_key: :invited_by_id, required: false

  validates :employee_id, presence: true
  validates :employee_id, uniqueness: true

  def to_s
    email
  end
end
