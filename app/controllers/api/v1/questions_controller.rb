class Api::V1::QuestionsController < Api::V1::BaseController
  include ActiveStorage::SetCurrent

  load_and_authorize_resource

  def index
    render json: @questions
  end

  def show
    render json: @question
  end
end
