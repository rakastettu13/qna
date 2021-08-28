FactoryBot.define do
  factory :achievement do
    name { 'MyString' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/features/achievement/test_image.png')) }
    question
    association :winner, factory: :user
  end
end
