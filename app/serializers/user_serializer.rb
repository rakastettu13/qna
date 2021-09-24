class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :achievements, :created_at, :updated_at
end
