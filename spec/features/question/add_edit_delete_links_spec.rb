require 'rails_helper'

RSpec.feature 'The user can attach links when creating and updating a question, edit and delete attached links',
              type: :feature do
  given(:user) { create(:user) }
  given(:qna_url) { 'https://github.com/rakastettu13/qna' }
  given(:gist_url) { 'https://github.com/rakastettu13/qna' }

  scenario 'The user can attach links when creating a question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Some text'

    fill_in 'Name', with: 'qna link'
    fill_in 'Url', with: qna_url

    click_on 'add link'

    within all('.nested-fields')[1] do
      fill_in 'Name', with: 'gist link'
      fill_in 'Url', with: gist_url
    end

    click_on 'Ask'

    expect(find('.question-links')).to have_link 'qna link', href: qna_url
    expect(find('.question-links')).to have_link 'gist link', href: gist_url
  end
end
