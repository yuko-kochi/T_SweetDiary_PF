FactoryBot.define do
  factory :post do
    introduction { Faker::Lorem.characters(number: 100) }
    user
  end
end
