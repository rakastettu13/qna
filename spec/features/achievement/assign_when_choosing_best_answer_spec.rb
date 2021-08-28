require 'rails_helper'

RSpec.feature 'When the author of the question chooses the best answer, the author of the answer gets an achievement' do
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:achievement) do
    create(:achievement, question: question, image: find_file('spec/features/achievement/test_image.png').first)
  end

  scenario 'The author of the best answer gets an achievement', js: true do
    sign_in(question.author)
    visit question_path(question)
    click_on 'Best'

    click_on 'Log out'
    sign_in(answer.author)
    visit received_achievements_path

    expect(page).to have_content achievement.name
  end
end
