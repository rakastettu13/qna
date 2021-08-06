require 'rails_helper'

RSpec.feature 'Destroying the question', type: :feature do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'Authorized user tries to delete the question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete the question'

    expect(page).to have_content 'Your question successfully deleted.'
  end

  scenario 'Unauthorized user tries to delete the question' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to have_no_content 'Delete the question'
  end

  scenario 'Unauthenticated user tries to delete the question' do
    visit question_path(question)

    expect(page).to have_no_content 'Delete the question'
  end
end