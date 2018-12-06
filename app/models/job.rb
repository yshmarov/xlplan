class Job < ApplicationRecord

  acts_as_tenant

  #after_save :update_associated_columns
  #after_update :update_associated_columns
  after_create :update_associated_columns
  after_update :update_ends_at
  after_create :update_due_prices
  after_update :update_due_prices
  after_save :update_due_prices
  after_save :touch_associations
  after_create :touch_associations

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  #counter_cache for job_count
  #touch to calculate balance
  belongs_to :client, touch: true, counter_cache: true
  belongs_to :service, counter_cache: true
  belongs_to :location, touch: true, counter_cache: true
  belongs_to :employee, touch: true, counter_cache: true
  belongs_to :creator, class_name: 'Employee', foreign_key: :created_by, required: false
  #has_many :comments, as: :commentable

  enum status: { planned: 0, confirmed: 1, confirmed_by_client: 2,
                  not_attended: 3, rejected_by_us:4, cancelled_by_client: 5}

  scope :mark_attendance, -> { where("starts_at < ?", Time.zone.now+15.minutes).where(status: 'planned') }
  scope :upcoming, -> { where("starts_at > ?", Time.zone.now-15.minutes).where(status: 'planned') }
  scope :is_confirmed, -> { where(status: [:confirmed, :confirmed_by_client]) }
  scope :is_cancelled, -> { where(status: [:not_attended, :rejected_by_us, :cancelled_by_client]) }
  scope :is_planned, -> { where(status: [:planned]) }
  def happened
    if status == 'confirmed_by_client' || status == 'confirmed'
      true
    elsif status == 'not_attended' || status == 'rejected_by_us' || status == 'cancelled_by_client' || status == 'planned'
      false
    end
  end


  def color
    if status == 'confirmed_by_client' || status == 'confirmed'
      'green'
    elsif status == 'not_attended'
      'red'
    elsif status == 'rejected_by_us' || status == 'cancelled_by_client'
      'grey'
    elsif status == 'planned'
      'blue'
    else
      'black'
    end
  end

  #console commands to update counters, if needed
  #Client.find_each { |client| Client.reset_counters(client.id, :jobs_count) }
  #Service.find_each { |service| Service.reset_counters(service.id, :jobs_count) }
  #Location.find_each { |location| Location.reset_counters(location.id, :jobs_count) }
  #Employee.find_each { |employee| Employee.reset_counters(employee.id, :jobs_count) }
  #ServiceCategory.find_each { |service_category| ServiceCategory.reset_counters(service_category.id, :services_count) }
  #Client.find_each { |client| Client.reset_counters(client.id, :comments_count) }
  #Location.find_each { |location| Location.reset_counters(location.id, :workplaces_count) }

  validates :client_id, :starts_at, :status, :service_id, :location_id, :employee_id,
            :service_name, :service_duration, :service_employee_percent, :client_price,
             :employee_price, presence: true

  #add_index :jobs, :status

  monetize :client_price, as: :client_price_cents
  monetize :employee_price, as: :employee_price_cents
  monetize :client_due_price, as: :client_due_price_cents
  monetize :employee_due_price, as: :employee_due_price_cents

  def to_s
    id
  end

  protected

  def touch_associations
    client.update_balance
    employee.update_balance
    location.update_balance
  end

  def update_associated_columns
    update_column :service_name, (service.name)
    update_column :service_description, (service.description)
    update_column :service_duration, (service.duration)
    update_column :client_price, (service.client_price)
    update_column :employee_price, (service.employee_price)
    update_column :ends_at, (starts_at + service_duration*60)
    update_column :service_employee_percent, (service.employee_percent)
  end

  def update_ends_at
    update_column :ends_at, (starts_at + service_duration*60)
  end

  def update_due_prices
    if self.happened
      update_column :client_due_price, (client_price)
      update_column :employee_due_price, (employee_price)
    else
      update_column :client_due_price, (0)
      update_column :employee_due_price, (0)
    end
  end

end
