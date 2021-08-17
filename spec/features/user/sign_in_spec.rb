require 'rails_helper'

feature 'User can sign in' do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    within('.actions') { click_on 'Log in' }

    expect(page).to have_content 'Signed in successfully.'
    expect(find('.user_links')).to have_content 'Log out'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'

    within('.actions') { click_on 'Log in' }

    expect(page).to have_content 'Invalid Email or password.'

    within('.user_links') do
      expect(page).to have_content 'Log in'
      expect(page).to have_content 'Sign up'
    end
  end
end
