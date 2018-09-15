class Shop < ApplicationRecord
  # model association
  has_many :orders, dependent: :destroy
  has_many :products, dependent: :destroy

  # validations
  validates_presence_of :name
end
