class Comment < ApplicationRecord
  belongs_to :person
  belongs_to :commentable, polymorphic: true

end
