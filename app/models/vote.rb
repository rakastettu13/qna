class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :point, numericality: { only_integer: true, greater_than_or_equal_to: -1, less_than_or_equal_to: 1 }
  validates :user, uniqueness: { scope: %i[votable_id votable_type] }
  validate :user, :validate_user_cannot_be_author_of_votable

  private

  def validate_user_cannot_be_author_of_votable
    errors.add(:user, 'cannot be the author of votable') if user&.author_of?(votable)
  end
end
