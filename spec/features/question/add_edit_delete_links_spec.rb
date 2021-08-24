require 'rails_helper'

RSpec.feature 'The user can attach links when creating and updating a question, edit and delete attached links',
              type: :feature do
  given(:user) { create(:user) }
  given(:qna_url) { 'https://github.com/rakastettu13/qna' }

  scenario 'The user can attach link when creating a question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Some text'

    fill_in 'Name', with: 'qna link'
    fill_in 'Url', with: qna_url

    click_on 'Ask'

    expect(find('.question-links')).to have_link 'qna link', href: qna_url
  end
end
