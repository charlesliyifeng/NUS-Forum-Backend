class Question < ApplicationRecord
  # relationships
  has_many :answers, dependent: :delete_all
  belongs_to :user

  # scopes
  scope :has_no_answer, -> { includes(:answers).where(answers: { id: nil }) }
  scope :has_accepted, -> { includes(:answers).where(answers: { accepted: 1 }) }
  scope :has_no_accepted, -> { where(Answer.where("question_id = questions.id").where(accepted: 1).arel.exists.not) }
  
  # validation / data cleaning
  validates :title, presence: true
  validates :body, presence: true
  auto_strip_attributes :tags, nullify: false, delete_whitespaces: true

  # voting system
  acts_as_votable cacheable_strategy: :update_columns
end
