class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :created_at, :updated_at

  has_many :questions
  has_many :answers
end
