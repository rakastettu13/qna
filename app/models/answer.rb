class Answer < ApplicationRecord
  default_scope { order(best: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many :links, as: :linkable, dependent: :destroy
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best
end
