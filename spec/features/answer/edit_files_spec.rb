require 'rails_helper'

RSpec.feature 'Only author of answer can edit or delete the attached files.', type: :feature, js: true do
  subject(:comment) { find('.answer-body') }

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer_with_attachments, author: user, question: question) }

  describe 'Author of answer', js: true do
    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'tries to add files' do
      within ".answer-#{answer.id}" do
        click_on 'Edit the answer'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        within '.answer-files' do
          expect(page).to have_link 'README.md'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'tries to delete attached files' do
      within '.answer-files' do
        expect(page).to have_link 'README.md'

        click_on "\u274c"

        expect(page).to have_no_link 'README.md'
      end
    end
  end

  scenario 'Another user tries to edit the attached file' do
    sign_in(another_user)
    visit question_path(question)

    expect(find('.answer-files')).to have_link 'README.md'
    expect(page).to have_no_link "\u274c"
    expect(page).to have_no_link 'Edit the answer'
  end

  scenario 'Unauthenticated user tries to edit the attached file' do
    visit question_path(question)

    expect(find('.answer-files')).to have_link 'README.md'
    expect(page).to have_no_link "\u274c"
    expect(page).to have_no_link 'Edit the answer'
  end
end
