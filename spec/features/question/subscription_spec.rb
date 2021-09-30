require 'rails_helper'

RSpec.feature 'Authenticated user can subscribe and unsubscribe to the question', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to subscribe to the question' do
      within('.subscription') do
        expect(page).to have_no_link 'unsubscribe'
        click_on 'subscribe'
        expect(page).to have_link 'unsubscribe'
      end
    end
  end

  describe 'Subscriber' do
    let!(:subscription) { create(:subscription, user: user, question: question) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to unsubscribe from a question' do
      within('.subscription') do
        click_on 'unsubscribe'
        expect(page).to have_link 'subscribe'
        expect(page).to have_no_link 'unsubscribe'
      end
    end
  end

  scenario 'Unauthenticated user tries to subscribe to the question' do
    visit question_path(question)

    expect(page).to have_no_link 'subscribe'
    expect(page).to have_no_link 'unsubscribe'
  end
end
