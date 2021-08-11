FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    factory :question_with_answers do
      title { 'MyString2' }
      body { 'MyText2' }

      transient do
        answers_count { 2 }
      end

      answers do
        Array.new(answers_count) { association(:answer) }
      end
    end
  end
end
