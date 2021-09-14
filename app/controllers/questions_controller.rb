class QuestionsController < ApplicationController
  include VotedFor

  before_action :authenticate_user!, only: :new

  load_and_authorize_resource

  before_action :set_variables, only: :show
  before_action :gon_variables, only: :show

  def new
    @question.build_achievement
  end

  def create
    @question.author = current_user

    if @question.save
      publish_question
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
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
    gon.question_id = @question.id
  end

  def publish_question
    ActionCable.server.broadcast('questions', ApplicationController.render(partial: 'questions/question',
                                                                           locals: { question: @question }))
  end

  def set_variables
    @answer = Answer.new
    @comment = Comment.new
    @comments = @question.comments.includes(:author)
    @answers = @question.answers.with_attached_files.includes(:author,
                                                              :links,
                                                              comments: :author)
  end
end
