# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Question

    return unless user.present?

    can :create, Question
    can %i[update destroy], Question, author_id: user.id
  end
end
