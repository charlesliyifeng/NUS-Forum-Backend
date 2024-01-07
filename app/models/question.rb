class Question < ApplicationRecord
  # relationships
  has_many :answers, dependent: :delete_all
  belongs_to :user
  
  # validation / data cleaning
  validates :title, presence: true
  validates :body, presence: true
  auto_strip_attributes :tags, nullify: false, delete_whitespaces: true

  # voting system
  acts_as_votable cacheable_strategy: :update_columns
end
