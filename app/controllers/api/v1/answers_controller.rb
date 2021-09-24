class Api::V1::AnswersController < Api::V1::BaseController
  include ActiveStorage::SetCurrent

  load_and_authorize_resource :question
  load_and_authorize_resource :answer, through: :question, shallow: true

  def index
    render json: @answers
  end

  def show
    render json: @answer
  end
end
