class LineItem < ApplicationRecord
  # model association
  belongs_to :product
  belongs_to :order

  # validations
  validates_presence_of :name
  validates_presence_of :cost
  validates_presence_of :quantity

  before_save :set_total

  after_save :update_order_total

  before_destroy :decrease_total


  private

  def set_total
    self.total = cost * quantity
  end

  def update_order_total
    new_total = order.line_items.sum(:total)

    return if order.total == new_total

    order.total = new_total
    order.save
  end

  def decrease_total
    order.total -= total
    order.save
  end
end
