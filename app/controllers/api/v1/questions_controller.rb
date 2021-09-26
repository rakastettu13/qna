class Api::V1::QuestionsController < Api::V1::BaseController
  include ActiveStorage::SetCurrent

  load_and_authorize_resource

  def index
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question.author = current_resource_owner

    if @question.save
      render json: @question
    else
      head :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[id name url _destroy])
  end
end
