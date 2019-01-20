class Job < ApplicationRecord

  acts_as_tenant

  after_touch :update_due_prices
  after_create :update_service_details
  after_save :update_service_details
  after_update :update_service_details

  after_create :update_service_details do event.update_client_price end
  after_save :update_service_details do event.update_client_price end
  after_update :update_service_details do event.update_client_price end

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  extend FriendlyId
  friendly_id :generated_slug, use: :slugged
  def generated_slug
    require 'securerandom' 
    @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(15) 
  end
  #friendly_id :full_name, use: :slugged
  #def full_name
  #  "#{created_at} #{service} for #{event.client} at #{event.starts_at} by #{member}"
  #end

  #counter_cache for job_count
  #touch to calculate balance
  belongs_to :member, touch: true, counter_cache: true
  belongs_to :service, counter_cache: true
  #touch to calculate duration and total_client_price
  belongs_to :event, touch: true, counter_cache: true

  #console commands to update counters, if needed
  #Client.find_each { |client| Client.reset_counters(client.id, :jobs_count) }
  #Service.find_each { |service| Service.reset_counters(service.id, :jobs_count) }
  #Location.find_each { |location| Location.reset_counters(location.id, :jobs_count) }
  #Employee.find_each { |member| Employee.reset_counters(member.id, :jobs_count) }
  #ServiceCategory.find_each { |service_category| ServiceCategory.reset_counters(service_category.id, :services_count) }
  #Client.find_each { |client| Client.reset_counters(client.id, :comments_count) }
  #Location.find_each { |location| Location.reset_counters(location.id, :workplaces_count) }

  validates :event, :service, :member,
            :service_duration, :service_member_percent, 
            :client_price, :member_price, presence: true

  ############GEM MONEY############
  monetize :client_price, as: :client_price_cents
  monetize :member_price, as: :member_price_cents
  monetize :client_due_price, as: :client_due_price_cents
  monetize :member_due_price, as: :member_due_price_cents

  def to_s
    if slug.present?; slug; else id; end
  end

  def update_due_prices
    if id?
      if event.status == 'confirmed'
        update_column :client_due_price, (client_price)
        update_column :member_due_price, (member_price)
      else
        update_column :client_due_price, (0)
        update_column :member_due_price, (0)
      end
    end
  end

  protected
  def update_service_details
    update_column :service_duration, (service.duration)
    update_column :client_price, (service.client_price)
    update_column :service_member_percent, (service.member_percent)
    update_column :member_price, (service.member_price)
  end

end
