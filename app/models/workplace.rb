class Workplace < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  belongs_to :location, counter_cache: true

  validates :name, uniqueness: true
  validates :name, :location_id, :status, presence: true

  enum status: { inactive: 0, active: 1 }

  def to_s
    name
  end

end
