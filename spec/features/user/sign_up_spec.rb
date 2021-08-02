require 'rails_helper'

feature 'User can sign up' do
  background { visit new_user_registration_path }

  describe 'The user tries to register' do
    scenario 'using a valid email and password' do
      fill_in 'Email', with: 'my@string.com'
      fill_in 'Password', with: 'MyString'
      fill_in 'Password confirmation', with: 'MyString'

      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'using an invalid email and password' do
      click_on 'Sign up'

      expect(page).to have_content 'errors prohibited this user from being saved:'
    end
  end
end
