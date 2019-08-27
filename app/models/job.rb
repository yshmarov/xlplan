class Job < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------gem rolify-------------------#
  resourcify
  #-----------------------relationships-------------------#
  #counter_cache for job_count
  #touch to calculate balance
  belongs_to :member, touch: true, counter_cache: true
  belongs_to :service, counter_cache: true
  #touch to calculate duration and total_client_price
  belongs_to :event, touch: true, counter_cache: true
  #-----------------------validation-------------------#
  validates :event, :service_id, :member,
            :service_duration, :service_member_percent, 
            :client_price, :member_price, presence: true
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  #-----------------------callbacks-------------------#
  after_touch :update_due_prices
  after_create :update_service_details
  after_save :update_service_details
  after_update :update_service_details

  after_create :update_service_details do event.update_client_price end
  after_save :update_service_details do event.update_client_price end
  after_update :update_service_details do event.update_client_price end

  #-----------------------rolify ownership-------------------#
  after_create :add_user_ownership
  after_update :add_user_ownership
  #after_destroy :destroy_user_ownership
  #remove_role 
  def add_user_ownership
    if self.member.user.present?
      user = member.user
      user.add_role(:owner, self) unless user.has_role?(:owner, self)
      user.add_role(:owner, self.event) unless user.has_role?(:owner, self.event)
    end
  end
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
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

  #-----------------------gem money-------------------#
  monetize :client_price, as: :client_price_cents
  monetize :member_price, as: :member_price_cents
  monetize :client_due_price, as: :client_due_price_cents
  monetize :member_due_price, as: :member_due_price_cents

  def to_s
    if slug.present?; slug; else id; end
  end

  def update_due_prices
    if id?
      if event.status == 'confirmed' || event.status == 'no_show_refunded'
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