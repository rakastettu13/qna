class QuestionsController < ApplicationController
  include VotedFor

  before_action :authenticate_user!, except: %i[index show]
  before_action :gon_variables, only: :show
  after_action :publish_question, only: :create

  expose :questions, -> { Question.all }
  expose :question, find: -> { Question.with_attached_files.find(params[:id]) }
  expose :answer, -> { question.answers.build }
  expose :comment, -> { Comment.new }

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
    authorize! :update, question

    question.update(question_params)
  end

  def destroy
    authorize! :destroy, question

    question.destroy
    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: %i[id name url _destroy],
                                     achievement_attributes: %i[id name image])
  end

  def gon_variables
    gon.user_id = current_user&.id
    gon.question_id = question.id
  end

  def publish_question
    return unless question.persisted?

    ActionCable.server.broadcast('questions', ApplicationController.render(partial: 'questions/question',
                                                                           locals: { question: question }))
  end
end
