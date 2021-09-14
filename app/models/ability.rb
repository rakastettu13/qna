# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Question

    return unless user.present?

    can :create, [Question, Answer]
    can %i[update destroy], [Question, Answer], author_id: user.id
    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    can :change_rating, [Question, Answer] do |resource|
      !user.voted_for?(resource) && !user.author_of?(resource)
    end
    can :cancel, [Question, Answer] do |resource|
      user.voted_for?(resource) && !user.author_of?(resource)
    end
  end
end
