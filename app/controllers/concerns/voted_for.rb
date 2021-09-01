module VotedFor
  extend ActiveSupport::Concern

  included do
    expose :resource, -> { send controller_name.singularize.to_sym }
  end

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

    respond_to do |format|
      format.json { render json: resource.rating }
    end
  end
end
