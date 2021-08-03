require 'rails_helper'

RSpec.feature 'Creating answer', type: :feature do
  given(:question) { create(:question) }

  describe 'Authenticated user'  do
    given(:user) { create(:user) }

    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'tries to send an answer' do
      fill_in 'Body', with: 'Some text'
      click_on 'Reply'

      expect(page).to have_content 'Your answer has been sent successfully.'
    end

    scenario 'tries to send an answer with errors' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to send an answer' do
      visit question_path(question)
      click_on 'Reply'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
