require 'rails_helper'

RSpec.feature 'Viewing a list of all questions', type: :feature do
  describe 'Any user sees headers' do
    background { visit questions_path }

    scenario 'with title, body, count of answers' do
      expect(page).to have_content('Title')
      expect(page).to have_content('Body')
      expect(page).to have_content('Count of answers')
    end
  end

  describe 'Any user sees questions' do
    subject(:questions_list) { find('.questions') }

    given!(:question1) { create(:question) }
    given!(:question2) { create(:question_with_answers) }

    background { visit questions_path }

    scenario 'with title, body, count of answers' do
      expect(questions_list).to have_content(question1.title)
      expect(questions_list).to have_content(question1.body)

      expect(questions_list).to have_content(question2.title)
      expect(questions_list).to have_content(question2.body)
      expect(questions_list).to have_content(question2.answers.count)
    end
  end
end
