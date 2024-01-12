class Comment < ApplicationRecord
  # relationships
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  # validation / data cleaning
  validates :body, presence: true
  auto_strip_attributes :body
end
