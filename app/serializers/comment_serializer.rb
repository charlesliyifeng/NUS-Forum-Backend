class CommentSerializer < ApplicationSerializer
  attributes :body
    
  attribute :author_id do |comment|
    if comment.user.nil?
      0
    else
      comment.user.id
    end
  end

  attribute :author_name do |comment|
    if comment.user.nil?
      "deleted user"
    else
      comment.user.name
    end
  end
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true
end
  