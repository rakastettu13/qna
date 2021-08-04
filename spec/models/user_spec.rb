require 'rails_helper'

RSpec.describe User, type: :model do
  context 'with questions' do
    it { is_expected.to have_many(:questions).dependent(:destroy) }
  end

  context 'with answers' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
  end

  describe 'have method author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:another_user) { create(:user) }

    it 'user is the author' do
      expect(user).to be_author_of question
    end

    it 'user is not the author' do
      expect(another_user).not_to be_author_of question
    end
  end
end
