require 'rails_helper'

RSpec.feature 'Viewing a question with answers', type: :feature do
  given(:question) { create(:question_with_answers) }

  background { visit question_path(question) }

  scenario 'Any user sees the questions' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question.author.email
    expect(page).to have_content question.created_at
  end

  scenario 'Any user sees the answers' do
    question.answers.each do |answer|
      expect(page).to have_content answer.body
      expect(page).to have_content answer.author.email
      expect(page).to have_content answer.created_at
    end
  end
end
