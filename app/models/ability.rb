class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    return unless user.present?

    can :create, :all
    can :received, Achievement
    can :me, User, id: user.id

    ability_to_vote(user)
    abilities_for_author(user)
  end

  private

  def abilities_for_author(user)
    can %i[update destroy], [Question, Answer], author_id: user.id
    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    can :best, Answer, question: { author_id: user.id }
  end

  def ability_to_vote(user)
    can :change_rating, [Question, Answer] do |resource|
      !user.voted_for?(resource) && !user.author_of?(resource)
    end

    can :cancel, [Question, Answer] do |resource|
      user.voted_for?(resource) && !user.author_of?(resource)
    end
  end
end
