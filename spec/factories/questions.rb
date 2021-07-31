FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }

    trait :invalid do
      title { nil }
    end

    factory :question_with_answers do
      title { 'MyString2' }
      body { 'MyText2' }
      answers { [association(:answer)] }
    end
  end
end
