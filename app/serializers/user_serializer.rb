class UserSerializer < ApplicationSerializer
  attributes :name

  attribute :email do |user, params|
    if params[:current_user] == user
      user.email
    else
      "hidden"
    end
  end

  has_many :questions
  has_many :answers
end
