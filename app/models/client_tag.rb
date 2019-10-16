class ClientTag < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant

  belongs_to :tag, counter_cache: true
  #Tag.find_each { |tag| Tag.reset_counters(tag.id, :idea_tags) }
  belongs_to :client
  #accepts_nested_attributes_for :tag, reject_if: :all_blank
  #validates :idea_id, :tag_id, presence: true
  #validates_uniqueness_of :tag_id, :scope => :idea_id


end