class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question
  expose :answer, parent: :question

  def create
    answer.author = current_user
    if answer.save
      redirect_to question, notice: 'Your answer has been sent successfully.'
    else
      render 'questions/show'
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to answer.question, notice: 'Your answer successfully deleted.'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
