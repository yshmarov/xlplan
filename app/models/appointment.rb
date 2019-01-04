class Appointment < ApplicationRecord
  belongs_to :tenant
  belongs_to :client
  belongs_to :member
  belongs_to :location
end
