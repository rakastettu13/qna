require 'rails_helper'

RSpec.shared_examples 'comment', js: true do |space|
  describe 'Authenticated user' do
    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'tries to add comment' do
      within(space) do
        fill_in 'Comment', with: 'Comment text'
        click_on 'Add comment'

        expect(page).to have_content 'Comment text'
      end
    end

    scenario 'tries to add comment with errors' do
      within(space) do
        click_on 'Add comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries to add the comment' do
    visit question_path(question)

    within(space) do
      click_on 'Add comment'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  scenario 'All users on question_path should see the created comment' do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within(space) do
        fill_in 'Comment', with: 'Comment text'
        click_on 'Add comment'

        expect(page).to have_content 'Comment text'
      end
    end

    Capybara.using_session('guest') do
      within(space) do
        expect(page).to have_content 'Comment text'
      end
    end
  end
end

RSpec.feature 'Authenticated user can add comment', type: :feature do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'for question' do
    include_examples 'comment', '.comments-cell'
  end

  describe 'for answer' do
    given!(:answer) { create(:answer, question: question) }

    include_examples 'comment', '.answers-cell'
  end
end
