class Comment < ApplicationRecord
  belongs_to :employee
  belongs_to :commentable, polymorphic: true, counter_cache: true
  validates :content, presence: true
end
