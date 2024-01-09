class Api::V1::QuestionsController < ApplicationController
  include JSONAPI::Fetching
  include JSONAPI::Pagination
  
  skip_before_action :authenticate_user, only: %i[ index show count get_answers ]
  before_action :set_question, only: %i[ show update destroy get_answers vote ]
  before_action :check_user_privilage, only: %i[ update destroy ]

  # GET /questions
  def index
    # search
    @questions = Question.all

    # filter
    @questions = case params[:filter]
    when "Accepted"
      @questions.has_accepted
    when "Not Accepted"
      @questions.has_no_accepted
    when "No Answer"
      @questions.has_no_answer
    else
      @questions
    end
    # sort
    @questions = case params[:sort]
    when "Newest"
      @questions.order(created_at: :desc)
    when "Votes"
      @questions.order(cached_votes_score: :desc)
    when "Answers"
      @questions.order(answers_count: :desc)
    when "Views"
      @questions.order(views: :desc)
    else
      @questions
    end
    # pagination
    jsonapi_paginate(@questions) do |paginated|
      render jsonapi: paginated
    end
  end

  # GET /questions/1
  def show
    # update question views
    @question.update_attribute(:views, @question.views + 1)
    render jsonapi: @question
  end

  # GET /questions/count
  def count
    @questions = Question.all
    # filter
    @questions = case params[:filter]
    when "Accepted"
      @questions.has_accepted
    when "Not Accepted"
      @questions.has_no_accepted
    when "No Answer"
      @questions.has_no_answer
    else
      @questions
    end
    render json: { count: @questions.count }
  end

  # GET /questions/1/get_answers
  def get_answers
    render jsonapi: Answer.where(question_id: @question.id).order(cached_votes_score: :desc, accepted: :desc)
  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.save
      render json: @question, status: :created
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1/vote
  def vote
    user_vote = params[:vote]
    if current_user.voted_for? @question
      # remove previous vote
      @question.unliked_by current_user
    else
      # cast current vote
      if user_vote.to_i == 1
        @question.liked_by current_user
      else
        @question.downvote_from current_user
      end
    end

    render jsonapi: @question
  end

  # DELETE /questions/1
  def destroy
    if @question.destroy
      render json: { success: "Question deleted" }, status: :ok
    else
      render json: { error: "Something went wrong" }, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
      unless @question
        render json: { error: 'Question not found' }, status: :not_found
      end
    end

    # check user access to question
    def check_user_privilage
      authenticate_target_user(@question.user_id)
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:title, :body, :views, :tags, :user_id)
    end

    def jsonapi_include
      super & ["user"]
    end

    def jsonapi_serializer_params
      {
        current_user: current_user
      }
    end
end
