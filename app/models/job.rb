class Job < ApplicationRecord
  belongs_to :client, touch: true, counter_cache: true
  belongs_to :service, counter_cache: true
  belongs_to :location, touch: true, counter_cache: true
  belongs_to :employee, touch: true, counter_cache: true
  #Client.find_each { |client| Client.reset_counters(client.id, :jobs_count) }
  #Service.find_each { |service| Service.reset_counters(service.id, :jobs_count) }
  #Location.find_each { |location| Location.reset_counters(location.id, :jobs_count) }
  #Employee.find_each { |employee| Employee.reset_counters(employee.id, :jobs_count) }

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
    update_column :client_price, (service.client_price_cents)
    update_column :employee_price, (service.employee_price_cents)
    update_column :ends_at, (starts_at + service_duration*60)
  end

  def to_s
    id
  end

  enum status: [:"Planned", :"Confirmed", :"Confirmed_by_client", 
                :"No_show", :"Rejected_by_us", :"Cancelled_by_client"]

end
