class LinkSerializer < ActiveModel::Serializer
  attributes :name, :url, :linkable_id, :linkable_type
end
