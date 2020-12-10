class Comment < ApplicationRecord
  acts_as_tenant

  include PublicActivity::Model
  tracked owner: proc { |controller, model| controller.current_user }
  tracked tenant_id: proc { Tenant.current_tenant.id }

  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count
  validates :content, presence: true
end
