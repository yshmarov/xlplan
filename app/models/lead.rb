class Lead < ApplicationRecord
  acts_as_tenant
  belongs_to :service
  belongs_to :member
  belongs_to :location
  validates :comment, length: { maximum: 500 }
  validates :first_name, :last_name, length: { maximum: 144 }
  validates :first_name, :last_name, :phone_number, presence: true
end
