class Order < ApplicationRecord
  # model association
  belongs_to :shop

  # validations
  validates_presence_of :date
end
