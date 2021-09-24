class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :author_id, :question_id, :created_at, :updated_at

  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer
end
