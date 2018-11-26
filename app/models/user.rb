class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :invitable, :validate_on_invite => true

  #include PublicActivity::Model
  #tracked only: :create, owner: :itself

  belongs_to :employee
  belongs_to :invitor, class_name: 'Employee', foreign_key: :invited_by_id, required: false

  #enum role: [:admin, :manager, :professional, :client ]

  validates :employee_id, presence: true
  validates :employee_id, uniqueness: true

  after_create :assign_default_role

  def to_s
    email
  end

  private

  def assign_default_role
    self.add_role(:professional) if self.roles.blank?
  end

end
