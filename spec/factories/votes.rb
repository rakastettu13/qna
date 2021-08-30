FactoryBot.define do
  factory :vote do
    user

    trait :for_question do
      association :votable, factory: :question
    end

    sequence :point do |n|
      if n.even?
        1
      else
        -1
      end
    end
  end
end
