class Lead < ApplicationRecord
  acts_as_tenant
  #belongs_to :tenant
  validates :first_name, :last_name, presence: true
end
