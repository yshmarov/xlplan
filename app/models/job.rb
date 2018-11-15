class Job < ApplicationRecord
  belongs_to :client, touch: true, counter_cache: true
  belongs_to :service, counter_cache: true
  belongs_to :location, touch: true, counter_cache: true
  belongs_to :employee, touch: true, counter_cache: true
  #has_many :comments, as: :commentable
  #Client.find_each { |client| Client.reset_counters(client.id, :jobs_count) }
  #Service.find_each { |service| Service.reset_counters(service.id, :jobs_count) }
  #Location.find_each { |location| Location.reset_counters(location.id, :jobs_count) }
  #Employee.find_each { |employee| Employee.reset_counters(employee.id, :jobs_count) }

  validates :client_id, :starts_at, :status, :service_id, :location_id, :employee_id,
            :service_name, :service_description, :service_duration, :client_price,
            :employee_price, presence: true

  enum status: [:"planned", :"confirmed", :"confirmed_by_client", 
                :"no_show", :"rejected_by_us", :"cancelled_by_client"]
  #enum localization: { home: 0, foreign: 1, none: 2 }
  #add_index :jobs, :status

  monetize :client_price, as: :client_price_cents
  monetize :employee_price, as: :employee_price_cents
  monetize :client_due_price, as: :client_due_price_cents
  monetize :employee_due_price, as: :employee_due_price_cents

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

  after_update :update_ends_at
  def update_ends_at
    update_column :ends_at, (starts_at + service_duration*60)
  end


  def event_happened
    if status == 'confirmed_by_client' || status == 'confirmed'
      true
    elsif status == 'no_show' || status == 'rejected_by_us' || status == 'cancelled_by_client' || status == 'planned'
      false
    end
  end

  after_create :update_due_prices
  after_update :update_due_prices
  def update_due_prices
    if self.event_happened
      update_column :client_due_price, (client_price)
      update_column :employee_due_price, (employee_price)
    else
      update_column :client_due_price, (0)
      update_column :employee_due_price, (0)
    end
  end


  def to_s
    id
  end

  def color
    if status == 'confirmed_by_client' || status == 'confirmed'
      'green'
    elsif status == 'no_show' || status == 'rejected_by_us' || status == 'cancelled_by_client'
      'red'
    elsif status == 'planned'
      'blue'
    else
      'black'
    end
  end

end
