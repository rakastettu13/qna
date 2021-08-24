require 'rails_helper'

RSpec.feature 'The user can attach links when creating and updating an answer, edit and delete attached links.',
              type: :feature do
  given(:user) { create(:user) }
  given(:qna_url) { 'https://github.com/rakastettu13/qna' }
  given(:gist_url) { 'https://gist.github.com/rakastettu13/' }
  given(:question) { create(:question) }

  before { sign_in(user) }

  scenario 'The user tries to attach links when creating an answer', js: true do
    visit question_path(question)

    fill_in 'Body', with: 'Some text'
    fill_in 'Name', with: 'qna link'
    fill_in 'Url', with: qna_url
    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Name', with: 'gist link'
      fill_in 'Url', with: gist_url
    end

    click_on 'Reply'

    within('.answer-links') do
      expect(page).to have_link 'qna link', href: qna_url
      expect(page).to have_link 'gist link', href: gist_url
    end
  end

  describe 'Author' do
    given!(:answer) { create(:answer, author: user, question: question) }
    given!(:link) { create(:link, linkable: answer, name: 'gist link', url: gist_url) }

    before { visit question_path(question) }

    scenario 'tries to add link when editing an answer', js: true do
      within(".answer-#{answer.id}") do
        click_on 'Edit the answer'
        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Name', with: 'qna link'
          fill_in 'Url', with: qna_url
        end

        click_on 'Save'
      end

      within('.answer-links') do
        expect(page).to have_link 'qna link', href: qna_url
        expect(page).to have_link 'gist link', href: gist_url
      end
    end

    scenario 'tries to delete link when editing an answer', js: true do
      expect(find('.answer-links')).to have_link link.name, href: link.url

      within(".answer-#{answer.id}") do
        click_on 'Edit the answer'
        click_on 'remove link'
        click_on 'Save'
      end

      expect(page).to have_no_link link.name, href: link.url
    end
  end
end
