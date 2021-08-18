FactoryBot.define do
  factory :answer do
    body { 'MyAnswer' }
    best { false }
    question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
