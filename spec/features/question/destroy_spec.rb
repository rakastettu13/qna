require 'rails_helper'

RSpec.feature 'Only author can delete his question.', type: :feature, js: true do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'Author tries to delete the question' do
    sign_in(user)
    visit question_path(question)

    expect(find('.question-title')).to have_content question.title

    click_on 'Delete the question'

    expect(page).to have_content 'Your question successfully deleted.'
    expect(page).to have_no_content question.title
  end

  scenario 'Another user tries to delete the question' do
    sign_in(another_user)
    visit question_path(question)

    expect(find('.question-title')).to have_content question.title
    expect(page).to have_no_content 'Delete the question'
  end

  scenario 'Unauthenticated user tries to delete the question' do
    visit question_path(question)

    expect(find('.question-title')).to have_content question.title
    expect(page).to have_no_content 'Delete the question'
  end
end
