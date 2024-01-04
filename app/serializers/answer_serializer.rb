class AnswerSerializer
  include JSONAPI::Serializer
  attributes :body, :votes, :created_at, :updated_at

  # convert accepted to boolean
  attribute :accepted do |answer|
    (answer.accepted == 1)
  end

  belongs_to :user
  belongs_to :question
end
