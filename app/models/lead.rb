class Lead < ApplicationRecord
  include Personable
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------relationships-------------------#
  belongs_to :service
  belongs_to :member
  belongs_to :location
  belongs_to :client
  #-----------------------validation-------------------#
  validates :first_name, :last_name, length: {maximum: 144}
  validates :comment, length: {maximum: 500}
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_blank: true

  validates :location_id, presence: true, if: :active_or_location?
  validates :service_id, presence: true, if: :active_or_service?
  validates :member_id, presence: true, if: :active_or_member?
  validates :first_name, :last_name, :phone_number, :conditions_consent, presence: true, if: :active_or_personal_data?
  def active?
    status == "active"
  end

  def active_or_location?
    if Location.active.online_booking.where(tenant_id: tenant_id).any?
      status.include?("select_location") || active?
    end
  end

  def active_or_service?
    if Service.active.online_booking.where(tenant_id: tenant_id).any?
      status.include?("select_service") || active?
    end
  end

  def active_or_member?
    if Member.active.online_booking.where(tenant_id: tenant_id).any?
      status.include?("select_member") || active?
    end
  end

  def active_or_personal_data?
    status.include?("personal_data") || active?
  end

  def can_create_client? # lead_to_client
    first_name.present? && last_name.present?
  end
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :generated_slug, use: :slugged
  def generated_slug
    require "securerandom"
    @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(8)
  end
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  # tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: proc { Tenant.current_tenant.id }
  #-----------------------scopes-------------------#
  scope :has_no_client, -> { where(client_id: nil) }
  scope :active, -> { where(status: "active") }
  # scope :with_present_titles, ->{where.not(title: [nil,'']) }
  #-----------------------capitalize coupon before_save-------------------#
  before_save do
    coupon.upcase! if coupon.present?
  end
end
