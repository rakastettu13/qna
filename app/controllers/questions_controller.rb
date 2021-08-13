class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question
  expose :answer, -> { question.answers.build }

  def create
    question.author = current_user
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      render :show
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
