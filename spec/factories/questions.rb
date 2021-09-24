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
      after(:build) do |question|
        create_list(:vote, 3, :for_question, votable: question)
      end
    end

    factory :question_with_attachments do
      files { [Rack::Test::UploadedFile.new(Rails.root.join('README.md'))] }
    end

    factory :question_with_associations do
      files do
        [Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')),
         Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb'))]
      end

      after(:build) do |question|
        create_list(:vote, 2, :for_question, votable: question)
        create_list(:link, 2, :for_question, linkable: question)
        create_list(:comment, 2, :for_question, commentable: question)
      end
    end
  end
end
