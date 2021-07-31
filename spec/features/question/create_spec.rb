require 'rails_helper'

RSpec.feature 'Creating question', type: :feature do
  background do
    visit questions_path
    click_on 'Ask question'
  end

  scenario 'asks a question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Some text'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Some text'
  end

  scenario 'asks a question with errors' do
    click_on 'Ask'

    expect(page).to have_content "Title/Body can't be blank"
  end
end
