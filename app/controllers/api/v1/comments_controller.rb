class Api::V1::CommentsController < ApplicationController
  include JSONAPI::Fetching

  skip_before_action :authenticate_user, only: %i[ index show ]
  before_action :set_comment, only: %i[ show update destroy ]
  before_action :check_user_privilage, only: %i[ update destroy ]

  # GET /comments
  def index
    @comments = Comment.all

    render json: @comments
  end

  # GET /comments/1
  def show
    render jsonapi: @comment
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body, :user_id, :commentable_type, :commentable_id)
    end

    # check user access to comment
    def check_user_privilage
      authenticate_target_user(@comment.user_id)
    end
end
