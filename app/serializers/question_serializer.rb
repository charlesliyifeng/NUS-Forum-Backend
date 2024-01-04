class QuestionSerializer
  include JSONAPI::Serializer
  attributes :title, :body, :votes, :views, :tags, :created_at, :updated_at

  # store answer count and accepted as meta
  meta do |question|
    { 
      answers_count: question.answers.length,
      accepted: question.answers.reduce(false) { |ys, x| ys || (x.accepted == 1) }
    }
  end

  has_many :answers do |question|
    question.answers.order(votes: :desc, accepted: :desc)
  end

  belongs_to :user
end
