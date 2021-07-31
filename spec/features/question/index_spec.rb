require 'rails_helper'

RSpec.feature 'Viewing a list of all questions', type: :feature do
  context 'with headers' do
    background { visit questions_path }

    scenario 'should contain headers' do
      expect(page).to have_content('Title')
      expect(page).to have_content('Body')
      expect(page).to have_content('Count of answers')
    end
  end

  context 'with content' do
    given!(:question1) { create(:question) }
    given!(:question2) { create(:question_with_answers) }

    background { visit questions_path }

    scenario 'should contain content' do
      [question1, question2].each do |question|
        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body)
        expect(page).to have_content(question.answers.count)
      end
    end
  end
end
