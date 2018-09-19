# app/serializers/shop_serializer.rb
class ShopSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :name, :created_by, :created_at, :updated_at
  # model association
  has_many :products
  has_many :orders
end
