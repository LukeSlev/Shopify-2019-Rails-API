class Order < ApplicationRecord
  # model association
  belongs_to :shop
  has_many :line_items

  # validations
  validates_presence_of :date
end
