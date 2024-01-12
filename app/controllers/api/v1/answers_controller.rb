class Api::V1::AnswersController < ApplicationController
  include JSONAPI::Fetching

  skip_before_action :authenticate_user, only: %i[ index show ]
  before_action :set_answer, only: %i[ show update destroy accept vote ]
  before_action :check_user_answer_privilage, only: %i[ destroy update ]
  before_action :check_user_question_privilage, only: %i[ accept ]

  # GET /answers
  def index
    @answers = Answer.all
    render jsonapi: @answers
  end

  # GET /answers/1
  def show
    render jsonapi: @answer
  end

  # POST /answers
  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      render json: { success: "Answer created" }, status: :created
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /answers/1
  def update
    if @answer.update(answer_params)
      render json: { success: "Answer updated" }, status: :ok
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /answers/1/accept
  def accept
    # set accepted
    if answer_params[:accepted]
      new_accepted = 1
    else 
      new_accepted = 0
    end

    # update db
    if @answer.update_attribute(:accepted, new_accepted)
      render json: { success: "Answer accepted" }, status: :ok
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /answers/1/vote
  def vote
    # check if current_user is author of post
    if @answer.user == current_user
      render json: { error: "Cannot vote for own post" }, status: :forbidden
      return
    end

    user_vote = answer_params[:vote]
    if current_user.voted_for? @answer
      # remove previous vote
      @answer.unliked_by current_user
    else
      # cast current vote
      if user_vote.to_i == 1
        @answer.liked_by current_user
      else
        @answer.downvote_from current_user
      end
    end

    render json: { success: "Vote recorded" }, status: :ok
  end

  # DELETE /answers/1
  def destroy
    if @answer.destroy
      render json: { success: "Answer deleted" }, status: :ok
    else
      render json: { error: "Something went wrong" }, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
      unless @answer
        render json: { error: 'Answer not found' }, status: :not_found
      end
    end

    # check user access to answer
    def check_user_answer_privilage
      authenticate_target_user(@answer.user_id)
    end

    # check user access to question (to accept answer)
    def check_user_question_privilage
      question_id = Answer.find(params[:id]).question_id
      @question = Question.find_by(id: question_id)
      authenticate_target_user(@question.user_id)
    end

    # Only allow a list of trusted parameters through.
    def answer_params
      params.require(:answer).permit(:body, :vote, :accepted, :question_id, :user_id)
    end

    def jsonapi_include
      super & ["user", "comments"]
    end

    def jsonapi_serializer_params
      {
        current_user: current_user
      }
    end
end
