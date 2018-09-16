# spec/factories/line_items.rb
FactoryBot.define do
  factory :line_item do
    name { Faker::Lorem.word }
    product_id { nil }
    order_id { nil }
    cost { Faker::Number.decimal(2) }
    quantity { Faker::Number.number(2) }
    total { Faker::Number.decimal(2) }
  end
end
