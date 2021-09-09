require 'rails_helper'

RSpec.feature 'Only author can edit the answer.', type: :feature, js: true do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }

  describe 'Author' do
    background { sign_in(user) }

    background do
      visit question_path(question)
      click_on 'Edit the answer'
    end

    scenario 'tries to edit his answer' do
      within ".answer-#{answer.id}" do
        fill_in 'Body', with: 'Edited answer'
        click_on 'Save'

        expect(page).to have_no_content answer.body
        expect(page).not_to have_selector 'textarea'
        expect(find('.answer-body')).to have_content 'Edited answer'
      end
    end

    scenario 'tries to edit his answer with errors' do
      within ".answer-#{answer.id}" do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(find('.answer-body')).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Another user tries to edit the answer' do
    sign_in(another_user)
    visit question_path(question)

    expect(find('.answer-body')).to have_content answer.body
    expect(page).to have_no_content 'Edit the answer'
  end

  scenario 'Unauthenticated user tries to edit the answer' do
    visit question_path(question)

    expect(find('.answer-body')).to have_content answer.body
    expect(page).to have_no_content 'Edit the answer'
  end
end
