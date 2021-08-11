require 'rails_helper'

RSpec.describe User, type: :model do
  context 'with questions' do
    it { is_expected.to have_many(:questions).dependent(:destroy) }
  end

  context 'with answers' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
  end

  describe '#author_of?' do
    subject { user }

    let(:user) { create(:user) }

    context 'when user is the author' do
      let(:resource) { create(:question, author: user) }

      it { is_expected.to be_author_of(resource) }
    end

    context 'when user is not the author' do
      let(:resource) { create(:question) }

      it { is_expected.not_to be_author_of(resource) }
    end
  end
end
