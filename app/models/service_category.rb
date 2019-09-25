class ServiceCategory < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------relationships-------------------#
  has_many :services, dependent: :restrict_with_error
  has_many :skills, dependent: :restrict_with_error
  has_many :members, through: :skills
  has_many :jobs, through: :services
  #-----------------------validation-------------------#
  validates_uniqueness_of :name, scope: :tenant_id
  validates :name, presence: true
  validates :name, length: { maximum: 144 }
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :name, use: :slugged

  def to_s
    name
  end

end
