class Api::V1::AnswersController < ApplicationController
  before_action :set_answer, only: %i[ show update destroy accept ]
  before_action :set_question, only: %i[ create destroy accept ]

  # GET /answers
  def index
    @answers = Answer.all
    render json: @answers
  end

  # GET /answers/1
  def show
    render json: @answer
  end

  # POST /answers
  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      # update answers_count
      @question.answers_count += 1
      @question.save

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
    if @answer.accepted == 1
      new_accepted = 0
    else 
      new_accepted = 1
    end

    # update db
    if (@answer.update_attribute(:accepted, new_accepted) && @question.update_attribute(:accepted, new_accepted))
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /answers/1
  def destroy
    @answer.destroy

    # update question
    @question.answers_count -= 1
    @question.accepted = 0
    @question.save

    head :no_content
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

    # Only allow a list of trusted parameters through.
    def answer_params
      params.require(:answer).permit(:body, :author, :votes, :accepted, :question_id)
    end
end
