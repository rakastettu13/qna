module VotedFor
  extend ActiveSupport::Concern

  included do
    expose :resource, -> { send controller_name.singularize.to_sym }
  end

  def increase_rating
    resource.votes.create(user: current_user, point: 1)

    respond_to do |format|
      format.json { render json: question.rating }
    end
  end

  def decrease_rating
    resource.votes.create(user: current_user, point: -1)

    respond_to do |format|
      format.json { render json: question.rating }
    end
  end
end
