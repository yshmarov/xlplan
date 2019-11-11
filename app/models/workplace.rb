class Workplace < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------relationships-------------------#
  belongs_to :location
  #-----------------------validation-------------------#
  validates :name, presence: true
  validates :name, length: { maximum: 20 }
  def to_s
    name
  end
end