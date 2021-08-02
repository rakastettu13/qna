class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question
  expose :answer, -> { question.answers.build }

  def create
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      flash[:alert] = "Title/Body can't be blank"
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
