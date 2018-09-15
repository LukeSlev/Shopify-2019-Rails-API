# spec/factories/orders.rb
FactoryBot.define do
  factory :order do
    date { Faker::Date.between(2.days.ago, Date.today) }
    shop_id { Faker::Number(4) }
  end
end
