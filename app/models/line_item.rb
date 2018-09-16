class LineItem < ApplicationRecord
  # model association
  belongs_to :product
  belongs_to :order

  # validations
  validates_presence_of :name
  validates_presence_of :cost
  validates_presence_of :quantity

  before_save :set_total

  after_save :check_product

  private

  def set_total
    self.total = cost * quantity
  end

  def check_product
    cost = product.cost if cost != product.cost
    name = product.name if name != product.name
  end
end
