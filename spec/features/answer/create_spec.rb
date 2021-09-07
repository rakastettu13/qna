require 'rails_helper'

RSpec.feature 'Only authenticated user can answer the question.', type: :feature do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'tries to send an answer' do
      fill_in 'Body', with: 'Some text'
      click_on 'Reply'

      expect(find('.answer-body')).to have_content 'Some text'
    end

    scenario 'tries to send an answer with errors' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to send an answer with attached file' do
      fill_in 'Body', with: 'Some text'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Reply'

      expect(find('.answer-files')).to have_link 'rails_helper.rb'
      expect(find('.answer-files')).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to send an answer' do
    visit question_path(question)
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'All users on question_path should see the created answer', js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      fill_in 'Body', with: 'Answer text'
      click_on 'Reply'

      expect(page).to have_content 'Answer text'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Answer text'
    end
  end
end
