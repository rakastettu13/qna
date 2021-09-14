# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Question
    can :read, Achievement

    return unless user.present?

    can :create, [Question, Answer, Comment]
    can :received, Achievement
    can %i[update destroy], [Question, Answer], author_id: user.id
    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    can :best, Answer, question: { author_id: user.id }

    can :change_rating, [Question, Answer] do |resource|
      !user.voted_for?(resource) && !user.author_of?(resource)
    end

    can :cancel, [Question, Answer] do |resource|
      user.voted_for?(resource) && !user.author_of?(resource)
    end
  end
end
