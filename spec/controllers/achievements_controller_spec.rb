require 'rails_helper'

RSpec.describe AchievementsController, type: :controller do
  describe 'GET #received' do
    let(:user) { create(:user) }
    let!(:achievement) { create(:achievement, winner: user) }

    before do
      sign_in(user)
      get :received
    end

    it { is_expected.to render_template 'achievements/_achievement' }
  end
end
