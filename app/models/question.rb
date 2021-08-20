class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'

  has_many :answers, dependent: :destroy
  has_many_attached :files

  validates :title, presence: true
  validates :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end

  def update_best_answer(answer)
    transaction do
      best_answer&.update!(best: false)
      answer.update!(best: true)
    end
  end
end
