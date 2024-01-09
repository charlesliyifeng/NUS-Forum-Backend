class QuestionSerializer < ApplicationSerializer
  attributes :title, :views, :tag_list, :answers_count

  attribute :body do |question, params|
    if !!params[:include_body]
      question.body
    else
      ""
    end
  end

  attribute :votes do |question|
    question.cached_votes_score
  end

  attribute :accepted do |question|
    question.answers.reduce(false) { |ys, x| ys || (x.accepted == 1) }
  end

  attribute :user_vote do |question, params|
    if !!params[:current_user]
      if params[:current_user].voted_up_on? question
        1
      elsif params[:current_user].voted_down_on? question
        -1
      else
        0
      end
    else
      0
    end
  end

  has_many :answers do |question|
    question.answers.order(cached_votes_score: :desc, accepted: :desc)
  end

  belongs_to :user
end
