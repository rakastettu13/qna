require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.not_to be_able_to %i[create update destroy], Question }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:user_question) { create(:question, author: user) }
    let(:another_question) { create(:question) }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :create, Question }

    context 'when author' do
      it { is_expected.to be_able_to %i[update destroy], user_question }
    end

    context 'when not author' do
      it { is_expected.not_to be_able_to %i[update destroy], another_question }
    end
  end
end
