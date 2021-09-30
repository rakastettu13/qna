class Question < ApplicationRecord
  include Votable

  belongs_to :author, class_name: 'User'

  has_one :achievement, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :achievement, reject_if: :all_blank

  validates :title, presence: true
  validates :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end

  def update_best_answer(answer)
    transaction do
      best_answer&.update!(best: false)
      answer.update!(best: true)
      achievement&.update!(winner: answer.author)
    end
  end
end
