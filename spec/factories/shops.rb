# spec/factories/shops.rb
FactoryBot.define do
  factory :shop do
    name { Faker::Lorem.word }
    created_by { Faker::Number.number(2) }
  end
end
