class AnswerSerializer < ApplicationSerializer
  attributes :body

  # convert accepted to boolean
  attribute :accepted do |answer|
    (answer.accepted == 1)
  end

  attribute :votes do |answer|
    answer.cached_votes_score
  end

  attribute :user_vote do |answer, params|
    if !!params[:current_user]
      if params[:current_user].voted_up_on? answer
        1
      elsif params[:current_user].voted_down_on? answer
        -1
      else
        0
      end
    else
      0
    end
  end

  belongs_to :user
  belongs_to :question
end
