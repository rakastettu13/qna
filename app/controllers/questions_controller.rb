class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question, find: -> { Question.with_attached_files.find(params[:id]) }
  expose :answer, -> { question.answers.build }

  def new
    question.links.build
    question.build_achievement
  end

  def show
    answer.links.build
  end

  def create
    question.author = current_user
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author_of?(question)
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
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: %i[id name url _destroy],
                                     achievement_attributes: %i[id name image])
  end
end
