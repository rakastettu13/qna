class Answer < ApplicationRecord
  default_scope { order(best: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best
end
