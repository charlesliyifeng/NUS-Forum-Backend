class Question < ApplicationRecord
  has_many :answers, dependent: :delete_all
  belongs_to :user
  
  validates :title, presence: true
  validates :body, presence: true
  auto_strip_attributes :tags, nullify: false, delete_whitespaces: true
end
