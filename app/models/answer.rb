class Answer < ApplicationRecord
  # relationships
  belongs_to :question, counter_cache: true
  belongs_to :user

  # validation / data cleaning
  validates :body, presence: true
  auto_strip_attributes :body

  # voting system
  acts_as_votable cacheable_strategy: :update_columns
end
