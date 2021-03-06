class Role < ApplicationRecord
  # acts_as_universal
  acts_as_tenant

  ROLES = [:admin, :manager, :specialist, :viewer]

  def self.options
    ROLES.map { |role| [role.capitalize, role] }
  end

  # enum role: [:user, :admin, :silver, :gold, :platinum]

  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource,
    polymorphic: true,
    optional: true

  validates :resource_type,
    inclusion: {in: Rolify.resource_types},
    allow_nil: true

  # WARNING! it breaks the app. no roles get assigned
  # validates :name, inclusion: { in: ["admin", "manager", "specialist", "viewer"] }, uniqueness: true

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :tenant_id
  # validates :name, presence: true, uniqueness: true, length: {:in => 2..30}
  # validates :name, inclusion: { in: ["admin", "manager", "specialist", "viewer"] }, uniqueness: true

  # scope :admin_specialist_manager, -> { where(name: [:manager, :specialist, :admin]) }

  scopify
end
