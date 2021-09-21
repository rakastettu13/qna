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

    factory :question_with_votes do
      transient do
        votes_count { 3 }
      end

      after(:create) do |question, evaluator|
        create_list(:vote, evaluator.votes_count, :for_question, votable: question)
        question.reload
      end
    end

    factory :question_with_attachments do
      files do
        [Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')),
         Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb'))]
      end
    end
  end
end
