require 'rails_helper'

RSpec.feature 'The user can attach links when creating and updating a question, edit and delete attached links.',
              type: :feature do
  given(:user) { create(:user) }
  given(:qna_url) { 'https://github.com/rakastettu13/qna' }
  given(:gist_url) { 'https://gist.github.com/rakastettu13/' }

  before { sign_in(user) }

  scenario 'The user tries to attach links when creating a question', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Some text'
    fill_in 'Name', with: 'qna link'
    fill_in 'Url', with: qna_url
    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Name', with: 'gist link'
      fill_in 'Url', with: gist_url
    end

    click_on 'Ask'

    within('.question-links') do
      expect(page).to have_link 'qna link', href: qna_url
      expect(page).to have_link 'gist link', href: gist_url
    end
  end

  describe 'Author' do
    given(:question) { create(:question, author: user) }
    given!(:link) { create(:link, linkable: question, name: 'gist link', url: gist_url) }

    before { visit question_path(question) }

    scenario 'tries to add link when editing a question', js: true do
      within('.show-question') do
        click_on 'Edit the question'
        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Name', with: 'qna link'
          fill_in 'Url', with: qna_url
        end

        click_on 'Save'
      end

      within('.question-links') do
        expect(page).to have_link 'qna link', href: qna_url
        expect(page).to have_link 'gist link', href: gist_url
      end
    end

    scenario 'tries to delete link when editing a question', js: true do
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
