require 'rails_helper'

RSpec.feature 'The user can attach links when creating and updating a question, edit and delete attached links.',
              type: :feature do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/rakastettu13/15d341fd094a58ed1f56f6556b63cd08' }

  before { sign_in(user) }

  describe 'When creating a question' do
    before { visit new_question_path }

    scenario 'the user tries to attach links', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Some text'

      within('#links') do
        fill_in 'Name', with: 'example'
        fill_in 'Url', with: 'https://example.com'
        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Name', with: 'another example'
          fill_in 'Url', with: 'https://example.ru'
        end
      end

      click_on 'Ask'

      within('.question-links') do
        expect(page).to have_link 'example', href: 'https://example.com'
        expect(page).to have_link 'another example', href: 'https://example.ru'
      end
    end

    scenario 'the user tries to attach gist', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Some text'

      within('#links') do
        fill_in 'Name', with: 'test gist'
        fill_in 'Url', with: gist_url
      end

      click_on 'Ask'

      within('.question-links') do
        expect(page).to have_link 'test gist', href: gist_url
        expect(page).to have_content 'gist for tests'
      end
    end
  end

  describe 'When editing a question' do
    given(:question) { create(:question, author: user) }
    given!(:link) { create(:link, linkable: question, name: 'example', url: 'https://example.com') }

    before { visit question_path(question) }

    scenario 'the author tries to add the link', js: true do
      within('.show-question') do
        click_on 'Edit the question'
        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Name', with: 'another_example'
          fill_in 'Url', with: 'https://example.ru'
        end

        click_on 'Save'
      end

      within('.question-links') do
        expect(page).to have_link 'example', href: 'https://example.com'
        expect(page).to have_link 'another_example', href: 'https://example.ru'
      end
    end

    scenario 'the author tries to delete the link', js: true do
      expect(find('.question-links')).to have_link link.name, href: link.url

      within('.show-question') do
        click_on 'Edit the question'
        click_on 'remove link'
        click_on 'Save'
      end

      expect(page).to have_no_link link.name, href: link.url
    end
  end
end
