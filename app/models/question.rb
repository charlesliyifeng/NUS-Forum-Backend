class Question < ApplicationRecord
  has_many :answers, dependent: :delete_all
  belongs_to :user
  validates :title, presence: true
end
