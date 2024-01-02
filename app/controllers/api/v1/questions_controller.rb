class Api::V1::QuestionsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[ index show get_answers ]
  before_action :set_question, only: %i[ show update destroy get_answers ]
  before_action :check_user_privilage, only: %i[ update destroy ]

  # GET /questions
  def index
    @questions = Question.all
    render json: @questions
  end

  # GET /questions/1
  def show
    render json: @question
  end

  # GET /questions/1/get_answers
  def get_answers
    render json: Answer.where(question_id: @question.id).order(votes: :desc, accepted: :desc)
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
      params.require(:question).permit(:title, :body, :votes, :answers_count, :accepted, :views, :tags, :user_id)
    end
  
end
