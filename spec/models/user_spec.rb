require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
  it { is_expected.to have_many(:subscribed_to).through(:subscriptions) }
  it { is_expected.to have_many(:achievements) }

  describe '#author_of?' do
    subject(:user) { create(:user) }

    context 'when user is the author' do
      let(:resource) { create(:question, author: user) }

      it { is_expected.to be_author_of(resource) }
    end

    context 'when user is not the author' do
      let(:resource) { create(:question) }

      it { is_expected.not_to be_author_of(resource) }
    end
  end

  describe '#voted_for?' do
    subject(:user) { create(:user) }

    context 'when the user voted' do
      let(:resource) { create(:question) }
      let!(:vote) { create(:vote, :for_question, votable: resource, user: user) }

      it { is_expected.to be_voted_for(resource) }
    end

    context 'when the user did not vote' do
      let(:resource) { create(:question) }

      it { is_expected.not_to be_voted_for(resource) }
    end
  end
end
