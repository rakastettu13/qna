module VotedFor
  extend ActiveSupport::Concern

  included do
    expose :resource, -> { send controller_name.singularize.to_sym }
  end

  def increase_rating
    vote = resource.votes.build(user: current_user, point: 1)

    respond_to do |format|
      if vote.save
        format.json { render json: resource.rating }
      else
        format.json { render json: vote.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def decrease_rating
    vote = resource.votes.build(user: current_user, point: -1)

    respond_to do |format|
      if vote.save
        format.json { render json: resource.rating }
      else
        format.json { render json: { error: vote.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def cancel
    resource.votes.find_by(user: current_user).destroy

    respond_to do |format|
      format.json { render json: resource.rating }
    end
  end
end
