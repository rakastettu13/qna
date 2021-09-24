class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :author_id, :created_at, :updated_at

  has_many :answers
  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer
end
