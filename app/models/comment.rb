class Comment < ApplicationRecord
  belongs_to :employee
  belongs_to :commentable, polymorphic: true
  validates :content, presence: true
end
