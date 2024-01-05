class Api::V1::AnswersController < ApplicationController
  include JSONAPI::Fetching

  skip_before_action :authenticate_user, only: %i[ index show ]
  before_action :set_answer, only: %i[ show update destroy accept ]
  before_action :set_question, only: %i[ create destroy accept ]
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
      render json: @answer, status: :created
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /answers/1
  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  # PUT /answers/1/accept
  def accept
    # toggle accepted
    if answer_params[:accepted]
      new_accepted = 1
    else 
      new_accepted = 0
    end

    # update db
    if @answer.update_attribute(:accepted, new_accepted)
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
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

    def set_question
      # differentiate between create and delete request
      if (params.has_key?(:question_id)) 
        # create
        question_id = params[:question_id]
      else
        # delete
        question_id = Answer.find(params[:id]).question_id
      end
      @question = Question.find_by(id: question_id)
      unless @question
        render json: { error: 'Question id of answer not found' }, status: :not_found
      end
    end

    # check user access to answer
    def check_user_answer_privilage
      authenticate_target_user(@answer.user_id)
    end

    # check user access to question (to accept answer)
    def check_user_question_privilage
      authenticate_target_user(@question.user_id)
    end

    # Only allow a list of trusted parameters through.
    def answer_params
      params.require(:answer).permit(:body, :votes, :accepted, :question_id, :user_id)
    end

    def jsonapi_include
      super & ["user"]
    end
  
end
