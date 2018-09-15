class Product < ApplicationRecord
  # model association
  belongs_to :shop

  # validations
  validates_presence_of :name
  validates_presence_of :cost
end
