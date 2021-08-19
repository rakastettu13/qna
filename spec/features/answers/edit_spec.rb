require 'rails_helper'

RSpec.feature 'Editing the answer', type: :feature do
  subject(:comment) { find('.answer-body') }

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question, files: find_file('README.md')) }

  describe 'Authorized user', js: true do
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
        expect(page).to have_content 'Edited answer'
      end
    end

    scenario 'tries to edit his answer with errors' do
      within ".answer-#{answer.id}" do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'tries to add files' do
      within ".answer-#{answer.id}" do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(find('.answer-files')).to have_link 'README.md'
        expect(find('.answer-files')).to have_link 'rails_helper.rb'
        expect(find('.answer-files')).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthorized user tries to edit the answer' do
    sign_in(another_user)
    visit question_path(question)

    expect(comment).to have_content answer.body
    expect(page).to have_no_content 'Edit the answer'
  end

  scenario 'Unauthenticated user tries to edit the answer' do
    visit question_path(question)

    expect(comment).to have_content answer.body
    expect(page).to have_no_content 'Edit the answer'
  end
end
