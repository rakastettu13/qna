require 'rails_helper'

RSpec.feature 'The user can add an achievement for the best answer when creating a question' do
  let(:user) { create(:user) }
  let(:image_path) { "#{Rails.root}/spec/features/achievement/test_image.png" }

  before do
    sign_in(user)
    visit new_question_path
  end

  scenario 'The user tries to add an achievement' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Some text'

    within('.achievement') do
      fill_in 'Name', with: 'test achievement'
      attach_file 'Image', image_path
    end

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'

    visit achievements_path

    expect(page).to have_content 'test achievement'
    expect(page).to have_xpath "//img[contains(@src, 'test_image')]"
  end
end
