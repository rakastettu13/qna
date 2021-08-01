require 'rails_helper'

RSpec.feature 'Creating answer', type: :feature do
  given(:question) { create(:question) }

  background do
    visit question_path(question)
  end

  scenario 'send an answer' do
    fill_in 'Body', with: 'Some text'
    click_on 'Reply'

    expect(page).to have_content 'Your answer has been sent successfully.'
    expect(page).to have_content 'Some text'
  end

  scenario 'send an answer with errors' do
    click_on 'Reply'

    expect(page).to have_content "Body can't be blank"
  end
end
