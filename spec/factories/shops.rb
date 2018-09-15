# spec/factories/shops.rb
FactoryBot.define do
  factory :shop do
    name { Faker::Lorem.word }
  end
end
