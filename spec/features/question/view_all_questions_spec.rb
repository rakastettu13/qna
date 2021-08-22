require 'rails_helper'

RSpec.feature 'Any user can view a list of all the questions.', type: :feature do
  given!(:question) { create(:question) }
  given!(:another_question) { create(:question_with_answers) }

  background { visit questions_path }

  scenario 'The user sees headers' do
    expect(page).to have_content('Title')
    expect(page).to have_content('Body')
    expect(page).to have_content('Count of answers')
  end

  scenario 'The user sees questions' do
    within('.questions') do
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)

      expect(page).to have_content(another_question.title)
      expect(page).to have_content(another_question.body)
      expect(page).to have_content(another_question.answers.count)
    end
  end
end
