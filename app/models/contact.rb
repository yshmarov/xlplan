class Contact < ApplicationRecord
  acts_as_tenant
  validates :import_id, presence: true
  #validates :import_id, uniqueness: true, scope: :tenant_id
  validates_uniqueness_of :import_id, scope: :tenant_id
  belongs_to :client, inverse_of: :contact, optional: true
end