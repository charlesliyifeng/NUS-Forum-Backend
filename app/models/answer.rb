class Answer < ApplicationRecord
  # relationships
  belongs_to :question
  belongs_to :user

  # validation / data cleaning
  validates :body, presence: true

  # voting system
  acts_as_votable cacheable_strategy: :update_columns
end
