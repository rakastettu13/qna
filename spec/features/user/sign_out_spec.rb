require 'rails_helper'

feature 'User can sign out' do
  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'Authenticated user tries to sign out' do
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'

    within('.user_links') do
      expect(page).to have_content 'Log in'
      expect(page).to have_content 'Sign up'
    end
  end
end
