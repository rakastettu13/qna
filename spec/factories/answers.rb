FactoryBot.define do
  factory :answer do
    body { 'MyAnswer' }
    best { false }
    question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end

    factory :answer_with_votes do
      transient do
        votes_count { 3 }
      end

      after(:create) do |answer, evaluator|
        create_list(:vote, evaluator.votes_count, :for_answer, votable: answer)
        answer.reload
      end
    end

    factory :answer_with_attachments do
      files { [Rack::Test::UploadedFile.new(Rails.root.join('README.md'))] }
    end

    factory :answer_with_associations do
      files do
        [Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')),
         Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb'))]
      end

      after(:build) do |answer|
        create_list(:vote, 2, :for_answer, votable: answer)
        create_list(:link, 2, :for_answer, linkable: answer)
        create_list(:comment, 2, :for_answer, commentable: answer)
      end
    end
  end
end
