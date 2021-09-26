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

  def create
    @answer.author = current_resource_owner

    if @answer.save
      render json: @answer
    else
      head :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy])
  end
end
