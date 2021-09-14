class AnswersController < ApplicationController
  include VotedFor

  before_action :authenticate_user!, only: :create

  load_and_authorize_resource :question
  load_and_authorize_resource :answer, through: :question, shallow: true

  before_action :gon_variables, only: :create
  after_action :publish_answer, only: :create

  expose :question, -> { @question }
  expose :answer, -> { @answer }

  def create
    answer.author = current_user
    render json: answer.errors.full_messages, status: :unprocessable_entity unless answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy
  end

  def best
    answer.question.update_best_answer(answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def find_question
    if params[:question_id]
      Question.find(params[:question_id])
    else
      answer.question
    end
  end

  def gon_variables
    gon.user_id = current_user&.id
    gon.question_id = question.id
  end

  def publish_answer
    return unless answer.persisted?

    ActionCable.server.broadcast("questions/#{answer.question.id}",
                                 { css: 'answers',
                                   template: ApplicationController.render(partial: 'answers/answer',
                                                                          locals: {
                                                                            answer: answer, current_user: nil
                                                                          }) })
  end
end
