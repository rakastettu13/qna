require 'rails_helper'

RSpec.feature 'Authenticated user can vote for a question.', js: true do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:user_question) { create(:question, author: user) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'tries to increase the rating of the question' do
      visit question_path(question)

      within('.voting') do
        expect(page).to have_content '0'

        click_on '+'

        expect(page).to have_content '1'
      end
    end

    scenario 'tries to decrease the rating of the question' do
      visit question_path(question)

      within('.voting') do
        expect(page).to have_content '0'

        click_on '–'

        expect(page).to have_content '-1'
      end
    end

    scenario 'tries to change the rating of his question' do
      visit question_path(user_question)

      within('.voting') do
        expect(page).to have_no_link '+'
        expect(page).to have_no_link '-'
        expect(page).to have_content question.rating
      end
    end
  end

  scenario 'Unauthenticated user tries to change the rating of the question' do
    visit question_path(question)

    within('.voting') do
      expect(page).to have_content question.rating

      click_on '+'
    end

    expect(find('.voting-errors')).to have_content 'You need to sign in or sign up before continuing.'
  end
end
