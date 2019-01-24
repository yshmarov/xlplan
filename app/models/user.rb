class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_universal_and_determines_account
  has_one :member, :dependent => :destroy
  has_many :comments, :dependent => :nullify
  #belongs_to :invitor, class_name: 'Employee', foreign_key: :invited_by_id, required: false

  rolify
  #validates :roles, presence: true
  validate :must_have_a_role

  validates :email, presence: true
  #include PublicActivity::Model
  #tracked only: :create, owner: :itself

  after_create :assign_default_role
  #after_initialize :assign_default_role

  scope :online, lambda{ where("updated_at > ?", 10.minutes.ago) }

  def online?
    updated_at > 10.minutes.ago
  end

  def to_s
    member.to_s
  end

  private
  def must_have_a_role
    errors.add(:roles, "must have at least one role") unless roles.any?
  end

  def assign_default_role
    self.add_role(:specialist) if self.roles.blank?
  end

end
