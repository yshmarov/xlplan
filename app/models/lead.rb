class Lead < ApplicationRecord
  acts_as_tenant
  belongs_to :service
  belongs_to :member
  belongs_to :location
  validates :first_name, :last_name, :phone_number, presence: true
end
