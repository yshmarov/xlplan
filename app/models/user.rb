class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable
  #-----------------------gem milia-------------------#
  acts_as_universal_and_determines_account
  #-----------------------relationships-------------------#
  #has_one :member, :dependent => :destroy
  has_one :member, :dependent => :nullify
  #has_many :comments, :dependent => :nullify
  has_many :jobs, through: :member
  has_many :events, through: :jobs
  #belongs_to :invitor, class_name: 'Employee', foreign_key: :invited_by_id, required: false
  #-----------------------gem rolify-------------------#
  rolify
  #-----------------------validation-------------------#
  #validates :roles, presence: true
  validate :must_have_a_role, on: :update
  validates :email, presence: true
  #-----------------------gem public_activity-------------------#
  #include PublicActivity::Model
  #tracked only: :create, owner: :itself
  #-----------------------callbacks details-------------------#
  #after_initialize :assign_default_role
  after_create :assign_default_role
  #-----------------------scopes-------------------#
  scope :online, lambda{ where("updated_at > ?", 10.minutes.ago) }
  def online?
    updated_at > 10.minutes.ago
  end

  def to_s
    member.to_s
  end

  private
  def must_have_a_role
    unless Tenant.current_tenant.nil? 
      if member.present?
        errors.add(:roles, "must have at least one role") unless roles.any?
      end
    end
  end

  def assign_default_role
    unless self.has_role?(:specialist)
      self.add_role(:specialist)
    end
    #if self.roles.blank?
    #  self.add_role(:specialist)
    #end
  end
end
