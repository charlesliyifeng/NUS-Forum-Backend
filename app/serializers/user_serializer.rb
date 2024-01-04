class UserSerializer
  include JSONAPI::Serializer
  attribute :name

  has_many :questions
  has_many :answers
end
