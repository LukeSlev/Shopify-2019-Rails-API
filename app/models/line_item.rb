class LineItem < ApplicationRecord
  # model association
  belongs_to :product
  belongs_to :order

  # validations
  validates_presence_of :name
  validates_presence_of :cost
  validates_presence_of :quantity
  validates_presence_of :total
end
