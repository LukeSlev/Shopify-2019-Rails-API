# spec/factories/products.rb
FactoryBot.define do
  factory :product do
    name { Faker::Lorem.word }
    cost { Faker::Number.decimal(2) }
    shop_id nil
  end
end
