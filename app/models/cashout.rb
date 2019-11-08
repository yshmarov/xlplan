class Cashout < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------relationships-------------------#
  belongs_to :location, touch: true
  belongs_to :member
  #-----------------------validation-------------------#
  validates :amount, :office_id, :member_id, :amount_cents, presence: :true
  validates :amount_cents, :numericality => {:greater_than => -1000000, :less_than => 1000000}
  #-----------------------gem money-------------------#
  monetize :amount, as: :amount_cents

  default_scope { order(created_at: :desc) }

  #def self.latest_cash_collection
  #  order('created_at desc').first
  #end

  def created_at_correct
    created_at.strftime('%d/%m/%Y %H:%M')
  end

end