class AnswersController < ApplicationController
  expose :question
  expose :answer, parent: :question

  def create
    if answer.save
      redirect_to question, notice: 'Your answer has been sent successfully.'
    else
      flash[:alert] = "Body can't be blank"
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
