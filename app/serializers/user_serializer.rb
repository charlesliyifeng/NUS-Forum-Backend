class UserSerializer < ApplicationSerializer
  attributes :name

  has_many :questions
  has_many :answers
end
