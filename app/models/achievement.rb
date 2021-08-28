class Achievement < ApplicationRecord
  belongs_to :question
  belongs_to :winner, class_name: 'User', optional: true

  has_one_attached :image

  validates :name, presence: true
  validates :image, presence: true
end
