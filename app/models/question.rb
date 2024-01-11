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
  auto_strip_attributes :title
  auto_strip_attributes :body

  # voting system
  acts_as_votable cacheable_strategy: :update_columns

  # tagging system
  acts_as_taggable_on :tags

  # search system
  def self.ransackable_attributes(auth_object = nil)
    ["body", "title"] + _ransackers.keys
  end

  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
  end
end
