class Cashout < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :location, touch: true
  belongs_to :member

  monetize :amount, as: :amount_cents

  validates :amount, :office_id, :member_id, :amount_cents, presence: :true
  validates :amount_cents, :numericality => {:greater_than => -1000000, :less_than => 1000000}

  #def self.latest_cash_collection
  #  order('created_at desc').first
  #end

  def created_at_correct
    created_at.strftime('%d/%m/%Y %H:%M')
  end

end