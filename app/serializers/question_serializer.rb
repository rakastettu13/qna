class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :author_id

  belongs_to :author, serializer: UserSerializer
  has_many :answers
end
