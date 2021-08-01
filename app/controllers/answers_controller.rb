class AnswersController < ApplicationController
  before_action :set_question, only: %i[create]

  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to @question, notice: 'Your answer has been sent successfully.'
    else
      flash[:alert] = "Body can't be blank"
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
