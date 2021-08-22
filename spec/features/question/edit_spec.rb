require 'rails_helper'

RSpec.feature 'Only author can edit the question.', type: :feature do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Author', js: true do
    background { sign_in(user) }

    background do
      visit question_path(question)
      click_on 'Edit the question'
    end

    scenario 'tries to edit his question' do
      within '.show-question' do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited question'
        click_on 'Save'

        expect(page).to have_no_content question.title
        expect(page).to have_no_content question.body
        expect(page).not_to have_selector 'textarea'
        expect(find('.question-title')).to have_content 'Edited title'
        expect(find('.question-body')).to have_content 'Edited question'
      end
    end

    scenario 'tries to edit his question with errors' do
      within '.show-question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(find('.question-title')).to have_content question.title
        expect(find('.question-body')).to have_content question.body
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Another user tries to edit the question' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_no_content 'Edit the question'
  end

  scenario 'Unauthenticated user tries to edit the question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_no_content 'Edit the question'
  end
end
