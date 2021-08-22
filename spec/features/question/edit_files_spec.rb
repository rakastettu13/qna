require 'rails_helper'

RSpec.feature 'Only author of question can edit or delete the attached files.', type: :feature do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user, files: find_file('README.md')) }

  describe 'Author of question', js: true do
    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'tries to add files' do
      within '.show-question' do
        click_on 'Edit the question'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        within '.question-files' do
          expect(page).to have_link 'README.md'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'tries to delete attached files', js: true do
      within '.question-files' do
        expect(page).to have_link 'README.md'

        click_on "\u274c"

        expect(page).to have_no_link 'README.md'
      end
    end
  end

  scenario 'Another user tries to edit or delete attached files' do
    sign_in(another_user)
    visit question_path(question)

    expect(find('.question-files')).to have_link 'README.md'
    expect(page).to have_no_link "\u274c"
    expect(page).to have_no_content 'Edit the question'
  end

  scenario 'Unauthenticated user tries to edit or delete attached files' do
    visit question_path(question)

    expect(find('.question-files')).to have_link 'README.md'
    expect(page).to have_no_link "\u274c"
    expect(page).to have_no_link 'Edit the question'
  end
end
