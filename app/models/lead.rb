class Lead < ApplicationRecord
  include Personable
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------relationships-------------------#
  belongs_to :service
  belongs_to :member
  belongs_to :location
  #-----------------------validation-------------------#
  validates :comment, length: { maximum: 500 }
  validates :first_name, :last_name, length: { maximum: 144 }
  validates :first_name, :last_name, :phone_number, presence: true
  validates :conditions_consent, presence: true
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  #tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
end
