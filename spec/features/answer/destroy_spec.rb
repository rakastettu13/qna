require 'rails_helper'

RSpec.feature 'Only author can delete his answer.', type: :feature, js: true do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }

  scenario 'Author tries to delete the answer' do
    sign_in(user)
    visit question_path(question)

    expect(find('.answer-body')).to have_content answer.body

    click_on 'Delete the answer'

    expect(page).to have_no_content answer.body
  end

  scenario 'Another user tries to delete the answer' do
    sign_in(another_user)
    visit question_path(question)

    expect(find('.answer-body')).to have_content answer.body
    expect(page).to have_no_content 'Delete the answer'
  end

  scenario 'Unauthenticated user tries to delete the answer' do
    visit question_path(question)

    expect(find('.answer-body')).to have_content answer.body
    expect(page).to have_no_content 'Delete the answer'
  end
end
