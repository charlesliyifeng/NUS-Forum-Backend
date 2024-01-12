class Answer < ApplicationRecord
  # relationships
  belongs_to :question, counter_cache: true
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :delete_all

  # validation / data cleaning
  validates :body, presence: true
  auto_strip_attributes :body

  # voting system
  acts_as_votable cacheable_strategy: :update_columns
end
