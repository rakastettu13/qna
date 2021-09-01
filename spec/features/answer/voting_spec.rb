require 'rails_helper'

RSpec.feature 'Authenticated user can vote for an answer.', js: true do
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }

  describe 'Authenticated user' do
    let(:user_answer) { create(:answer, author: user) }

    before { sign_in(user) }

    scenario 'tries to increase the rating of the answer and cancel the vote' do
      visit question_path(answer.question)

      within(".answer-#{answer.id}") do
        within('.voting') do
          expect(page).to have_content '0'

          click_on '+'

          expect(page).to have_content '1'
          expect(page).to have_no_link '+'

          click_on 'cancel'

          expect(page).to have_link '+'
          expect(page).to have_link '–'
        end
      end
    end

    scenario 'tries to decrease the rating of the answer and cancel the vote' do
      visit question_path(answer.question)

      within(".answer-#{answer.id}") do
        within('.voting') do
          expect(page).to have_content '0'

          click_on '–'

          expect(page).to have_content '-1'
          expect(page).to have_no_link '–'

          click_on 'cancel'

          expect(page).to have_link '+'
          expect(page).to have_link '–'
        end
      end
    end

    scenario 'tries to change the rating of his answer' do
      visit question_path(user_answer.question)

      within(".answer-#{user_answer.id}") do
        within('.voting') do
          expect(page).to have_no_link '+'
          expect(page).to have_no_link '–'
          expect(page).to have_content answer.rating
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to change the rating of the answer' do
    visit question_path(answer.question)

    within(".answer-#{answer.id}") do
      within('.voting') do
        expect(page).to have_content answer.rating

        click_on '+'

        expect(find('.voting-errors')).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
