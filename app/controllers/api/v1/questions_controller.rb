class Api::V1::QuestionsController < ApplicationController
  include JSONAPI::Fetching
  include JSONAPI::Pagination
  
  skip_before_action :authenticate_user, only: %i[ index show get_answers ]
  before_action :set_question, only: %i[ show update destroy get_answers vote ]
  before_action :check_user_privilage, only: %i[ update destroy ]

  # GET /questions
  def index
    # omit body
    @include_body = false;

    # search
    #@q = Question.ransack(params[:q])
    #@questions = @q.result(distinct: true)
    @questions = Question.all

    # filter tags
    if params[:tags] != ""
      @questions = @questions.tagged_with(params[:tags].to_s.split(","), :any => true)
    end

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
    # include body
    @include_body = true;
    # update question views
    @question.update_attribute(:views, @question.views + 1)
    render jsonapi: @question
  end

  # GET /questions/1/get_answers
  def get_answers
    render jsonapi: Answer.where(question_id: @question.id).order(cached_votes_score: :desc, accepted: :desc)
  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.save
      render json: { success: "Question created" }, status: :created
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      render json: { success: "Question updated" }, status: :ok
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1/vote
  def vote
    # check if current_user is author of post
    if @question.user == current_user
      render json: { error: "Cannot vote for own post" }, status: :forbidden
      return
    end

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

    render json: { success: "Vote recorded" }, status: :ok
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
      params.require(:question).permit(:title, :body, :views, :tag_list, :user_id)
    end

    def jsonapi_include
      super & ["user"]
    end

    def jsonapi_serializer_params
      {
        current_user: current_user,
        include_body: @include_body
      }
    end

    def jsonapi_meta(resources)
      pagination = jsonapi_pagination_meta(resources)
  
      { pagination: pagination } if pagination.present?
    end
end
