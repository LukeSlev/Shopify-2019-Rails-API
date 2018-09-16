class Product < ApplicationRecord
  # model association
  belongs_to :shop
  has_many :line_items

  # validations
  validates_presence_of :name
  validates_presence_of :cost

  after_save :check_line_item

  private

  def check_line_item
    line_items.each do |li|
      next if cost != li.cost && li.name != name

      li.cost = cost if cost != li.cost
      li.name = name if name != li.name

      li.save
    end
  end
end
