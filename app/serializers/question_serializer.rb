class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :author_id

  belongs_to :author
  has_many :answers
  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer
end
