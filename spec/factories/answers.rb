FactoryBot.define do
  factory :answer do
    body { 'MyAnswer' }
    question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
