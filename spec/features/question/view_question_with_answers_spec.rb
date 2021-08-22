require 'rails_helper'

RSpec.feature 'Any user can view the question and the answers to it.', type: :feature do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, body: 'body 1') }
  given!(:another_answer) { create(:answer, question: question, body: 'body 2') }

  background { visit question_path(question) }

  scenario 'The user sees the question' do
    within('.show-question') do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content question.author.email
      expect(page).to have_content question.created_at
    end
  end

  scenario 'The user sees the answers' do
    within('.answers') do
      expect(page).to have_content answer.body
      expect(page).to have_content answer.author.email
      expect(page).to have_content answer.created_at

      expect(page).to have_content another_answer.body
      expect(page).to have_content another_answer.author.email
      expect(page).to have_content another_answer.created_at
    end
  end
end
