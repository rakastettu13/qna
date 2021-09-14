class AnswersController < ApplicationController
  include VotedFor

  before_action :authenticate_user!, only: :create

  load_and_authorize_resource :question
  load_and_authorize_resource :answer, through: :question, shallow: true

  def create
    @answer.author = current_user

    if @answer.save
      publish_answer
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def best
    @answer.question.update_best_answer(@answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def publish_answer
    ActionCable.server.broadcast("questions/#{@answer.question.id}",
                                 { css: 'answers',
                                   template: ApplicationController.render(partial: 'answers/answer',
                                                                          locals: {
                                                                            answer: @answer, current_user: nil
                                                                          }) })
  end
end
