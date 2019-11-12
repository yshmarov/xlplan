class Workplace < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------relationships-------------------#
  belongs_to :location
  #-----------------------validation-------------------#
  validates :name, presence: true
  validates :name, length: { maximum: 20 }
  validates_uniqueness_of :name, scope: :location_id
  def to_s
    #name
    name + "/" + location.name
  end
  def short_name
    to_s
  end
end