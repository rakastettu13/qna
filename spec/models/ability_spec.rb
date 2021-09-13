require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.not_to be_able_to %i[create update destroy], Question }
    it { is_expected.not_to be_able_to %i[create update destroy], Answer }
  end

  describe 'for user' do
    let(:user) { create :user }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }

    context 'when author' do
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, author: user) }

      it { is_expected.to be_able_to %i[update destroy], question }
      it { is_expected.to be_able_to %i[update destroy], answer }
    end

    context 'when not author' do
      let(:question) { create(:question) }
      let(:answer) { create(:answer) }

      it { is_expected.not_to be_able_to %i[update destroy], question }
      it { is_expected.not_to be_able_to %i[update destroy], answer }
    end
  end
end
