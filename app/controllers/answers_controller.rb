class AnswersController < ApplicationController
  include VotedFor

  before_action :authenticate_user!
  before_action :gon_variables, only: :create
  after_action :publish_answer, only: :create

  expose :question, -> { find_question }
  expose :answer, build: -> { question.answers.build(answer_params) }

  def create
    answer.author = current_user
    answer.save
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  def best
    question.update_best_answer(answer) if current_user.author_of?(question)
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

    ActionCable.server.broadcast("questions/#{question.id}",
                                 { css: 'answers',
                                   template: ApplicationController.render(partial: 'answers/answer',
                                                                          locals: {
                                                                            answer: answer, current_user: nil
                                                                          }) })
  end
end
