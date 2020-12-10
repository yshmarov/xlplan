class Tag < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant

  # has_many :client_tags, inverse_of: :tag, dependent: :destroy
  has_many :client_tags
  has_many :clients, through: :client_tags
  validates :name, length: {minimum: 1, maximum: 25}
  validates_uniqueness_of :name, scope: :tenant_id
  # default_scope { order(client_tags_count: :desc) }
  def to_s
    name
  end

  def popular_name
    "#{name}: #{client_tags_count}"
  end
end
