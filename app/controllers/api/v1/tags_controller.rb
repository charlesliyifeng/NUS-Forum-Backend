class Api::V1::TagsController < ApplicationController
  skip_before_action :authenticate_user, only: [:index]

  def index
    # search for similar tags
    @tags = ActsAsTaggableOn::Tag.where("name LIKE ?", "%" + params[:q] + "%")
    render json: @tags
  end
end
