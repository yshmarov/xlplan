class Contact < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------validation-------------------#
  validates :import_id, presence: true
  #validates :import_id, uniqueness: true, scope: :tenant_id
  validates_uniqueness_of :import_id, scope: :tenant_id
  #-----------------------relationships-------------------#
  belongs_to :client, inverse_of: :contact, optional: true
  #-----------------------scopes-------------------#
  scope :has_no_client, -> { where(client_id: nil) }
  #-----------------------gem public_activity-------------------#
  #include PublicActivity::Model
  #tracked owner: Proc.new{ |controller, model| controller.current_user }
  #tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
end