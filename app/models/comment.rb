class Comment < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  belongs_to :employee
  belongs_to :commentable, polymorphic: true, counter_cache: true
  validates :content, presence: true
end
