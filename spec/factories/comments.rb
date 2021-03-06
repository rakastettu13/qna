FactoryBot.define do
  factory :comment do
    body { 'MyComment' }
    association :author, factory: :user

    trait :for_question do
      association :commentable, factory: :question
    end

    trait :for_answer do
      association :commentable, factory: :answer
    end
  end
end
