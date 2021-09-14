module VotedFor
  extend ActiveSupport::Concern

  def change_rating
    vote = resource.votes.build(user: current_user, point: params[:point])

    if vote.save
      render json: resource.rating
    else
      render json: { error: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def cancel
    resource.votes.find_by(user: current_user).destroy

    render json: resource.rating
  end

  private

  def resource
    instance_variable_get "@#{controller_name.singularize}"
  end
end
