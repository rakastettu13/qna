require 'rails_helper'

feature 'User can sign up' do
  background { visit new_user_registration_path }

  scenario 'with valid email and password' do
    fill_in 'Email', with: 'my@string.com'
    fill_in 'Password', with: 'MyString'
    fill_in 'Password confirmation', with: 'MyString'

    within('.actions') { click_on 'Sign up' }

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(find('.user_links')).to have_content 'Log out'
  end

  scenario 'with invalid email and password' do
    within('.actions') { click_on 'Sign up' }

    expect(page).to have_content 'errors prohibited this user from being saved:'

    within('.user_links') do
      expect(page).to have_content 'Log in'
      expect(page).to have_content 'Sign up'
    end
  end
end
