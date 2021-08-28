require 'rails_helper'

RSpec.feature 'The user can view achievements.' do
  let(:user) { create(:user) }
  let!(:achievement) { create(:achievement, name: 'some achievement') }
  let!(:received_achievement) { create(:achievement, name: 'received achievement', winner: user) }

  describe 'Unauthenticated user' do
    before { visit achievements_path }

    scenario 'tries view all achievements' do
      visit achievements_path

      expect(page).to have_content achievement.name
      expect(page).to have_content achievement.question.title
      expect(page).to have_xpath "//img[contains(@src, 'test_image')]"
      expect(page).to have_content received_achievement.name
      expect(page).to have_link 'Your achievements', href: received_achievements_path
    end

    scenario 'tries view received achievements' do
      click_on 'Your achievements'

      expect(page).to have_content 'You need to sign in or sign up before continuing'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit achievements_path
    end

    scenario 'tries view received achievements' do
      click_on 'Your achievements'

      expect(page).to have_content received_achievement.name
      expect(page).to have_content received_achievement.question.title
      expect(page).to have_xpath "//img[contains(@src, 'test_image')]"
      expect(page).to have_no_content achievement.name
      expect(page).to have_link 'All achievements', href: achievements_path
    end
  end
end
