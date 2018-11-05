class Event < ApplicationRecord
  belongs_to :client
  belongs_to :service
  belongs_to :location
  belongs_to :employee

  validates :client_id, :start, :status, :service_id, :location_id, :employee_id,
            :service_name, :service_description, :service_duration, :client_price,
            :employee_price, presence: true

  after_save :update_associated_columns
  #after_update :update_associated_columns
  def update_associated_columns
    update_column :service_name, (service.name)
    update_column :service_description, (service.description)
    update_column :service_duration, (service.duration)
    update_column :client_price, (service.client_price)
    update_column :employee_price, (service.employee_price)
  end


  def to_s
    id
  end

  enum status: [:"Planned", :"Confirmed", :"Client_no_appear", 
                :"Rejected_by_us", :"Cancelled_by_client", :"Confirmed_by_client"]

end
