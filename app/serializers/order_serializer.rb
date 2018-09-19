class OrderSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :date, :shop_id, :created_at, :updated_at, :total
  # model association
  has_many :line_items
end
