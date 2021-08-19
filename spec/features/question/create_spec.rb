require 'rails_helper'

RSpec.feature 'Creating question', type: :feature do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:fill_in_all_fields) do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Some text'
    end

    background { sign_in(user) }
    background do
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'tries to ask a question' do
      fill_in_all_fields

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(find('.question-title')).to have_content 'Test question'
      expect(find('.question-body')).to have_content 'Some text'
    end

    scenario 'tries to ask a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to ask a question with attached file' do
      fill_in_all_fields
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(find('.question-files')).to have_link 'rails_helper.rb'
      expect(find('.question-files')).to have_link 'spec_helper.rb'
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
