class Job < ApplicationRecord
  belongs_to :client, touch: true
  belongs_to :service
  belongs_to :location
  belongs_to :employee, touch: true

  validates :client_id, :starts_at, :status, :service_id, :location_id, :employee_id,
            :service_name, :service_description, :service_duration, :client_price,
            :employee_price, presence: true

  monetize :client_price, as: :client_price_cents
  monetize :employee_price, as: :employee_price_cents

  #after_save :update_associated_columns
  #after_update :update_associated_columns
  after_create :update_associated_columns
  def update_associated_columns
    update_column :service_name, (service.name)
    update_column :service_description, (service.description)
    update_column :service_duration, (service.duration)
    update_column :client_price, (service.client_price)
    update_column :employee_price, (service.employee_price)
    update_column :ends_at, (starts_at + service_duration*60)
  end

  def to_s
    id
  end

  enum status: [:"Planned", :"Confirmed", :"Confirmed_by_client", 
                :"No_show", :"Rejected_by_us", :"Cancelled_by_client"]

end
