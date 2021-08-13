class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question, -> { find_question }
  expose :answer, build: -> { question.answers.build(answer_params) }

  def create
    answer.author = current_user
    answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    if params[:question_id]
      Question.find(params[:question_id])
    else
      answer.question
    end
  end
end
