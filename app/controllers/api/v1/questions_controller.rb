class Api::V1::QuestionsController < ApplicationController
  before_action :set_question, only: %i[ show update destroy ]

  # GET /questions
  def index
    @questions = Question.all
    render json: @questions
  end

  # GET /questions/1
  def show
    render json: @question
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
    @question.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
      unless @question
        render json: { error: 'Thread not found' }, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:title, :body, :author, :votes, :answers, :accepted, :views, :tags)
    end
end
