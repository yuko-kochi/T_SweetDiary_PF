FactoryBot.define do
  factory :post do
    introduction { Faker::Lorem.characters(number: 100) }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    category_id {'2'}
    start_time {'2021,7,28'}
    user
  end
end