require 'rails_helper'

RSpec.feature 'Best answer', type: :feature do
  subject(:comment) { find('.answer-body') }

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authorized user', js: true do
    given!(:another_answer) { create(:answer, body: 'another answer body', question: question) }

    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'tries to choose the best answer' do
      within ".answer-#{answer.id}" do
        expect(page).to have_no_content 'Best answer'

        click_on 'Best'

        expect(page).to have_content 'Best answer'
        expect(page).to have_no_link 'Best'
      end
    end

    scenario 'tries to choose another best answer' do
      within ".answer-#{answer.id}" do
        click_on 'Best'
      end

      expect(find('.answer-body', match: :first)).to have_content answer.body
      expect(find('.answer-body', match: :first)).to have_no_content another_answer.body

      within ".answer-#{another_answer.id}" do
        click_on 'Best'

        expect(page).to have_content 'Best answer'
        expect(page).to have_no_link 'Best'
      end

      expect(find('.answer-body', match: :first)).to have_content another_answer.body
      expect(find('.answer-body', match: :first)).to have_no_content answer.body

      within ".answer-#{answer.id}" do
        expect(page).to have_no_content 'Best answer'
        expect(page).to have_link 'Best'
      end
    end
  end

  scenario 'Unauthorized user tries to choose the best answer' do
    sign_in(another_user)
    visit question_path(question)

    expect(comment).to have_content answer.body
    expect(page).to have_no_content 'Best'
  end

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(question)

    expect(comment).to have_content answer.body
    expect(page).to have_no_content 'Best'
  end
end
