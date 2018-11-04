class Event < ApplicationRecord
  belongs_to :client
  belongs_to :service
  belongs_to :location
  belongs_to :employee

  validates :client_id, :start, :status, :service_id, :location_id, :employee_id,
            :service_name, :service_description, :service_duration, :client_price,
            :employee_price, presence: true

  def to_s
    id
  end

  enum status: [:"Planned", :"Confirmed", :"Client_no_appear", 
                :"Rejected_by_us", :"Cancelled_by_client", :"Confirmed_by_client"]

end
