require 'rails_helper'

RSpec.feature 'Creating question', type: :feature do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }
    background do
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'tries to ask a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Some text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
    end

    scenario 'tries to ask a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title/Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to ask a question' do
      visit questions_path
      click_on 'Ask question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
