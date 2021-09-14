require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.not_to be_able_to %i[create update destroy], Question }
    it { is_expected.not_to be_able_to %i[create update destroy], Answer }
    it { is_expected.not_to be_able_to %i[destroy], ActiveStorage::Attachment }
    it { is_expected.not_to be_able_to :change_rating, Question }
    it { is_expected.not_to be_able_to :change_rating, Answer }
    it { is_expected.not_to be_able_to :cancel, Question }
    it { is_expected.not_to be_able_to :cancel, Answer }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }
    it { is_expected.not_to be_able_to %i[update destroy], question }
    it { is_expected.not_to be_able_to %i[update destroy], answer }
    it { is_expected.not_to be_able_to %i[destroy], create(:question_with_attachments).files.last }

    context 'when he did not vote' do
      it { is_expected.to be_able_to :change_rating, question }
      it { is_expected.to be_able_to :change_rating, answer }
      it { is_expected.not_to be_able_to :cancel, question }
      it { is_expected.not_to be_able_to :cancel, answer }
    end

    context 'when he voted' do
      let!(:vote_for_question) { create(:vote, :for_question, votable: question, user: user) }
      let!(:vote_for_answer) { create(:vote, :for_answer, votable: answer, user: user) }

      it { is_expected.not_to be_able_to :change_rating, question }
      it { is_expected.not_to be_able_to :change_rating, answer }
      it { is_expected.to be_able_to :cancel, question }
      it { is_expected.to be_able_to :cancel, answer }
    end
  end

  describe 'for author' do
    let(:user) { create :user }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, author: user) }
    let(:attachment) { create(:question_with_attachments, author: user).files.last }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }
    it { is_expected.to be_able_to %i[update destroy], question }
    it { is_expected.to be_able_to %i[update destroy], answer }
    it { is_expected.to be_able_to %i[destroy], attachment }
    it { is_expected.not_to be_able_to :change_rating, question }
    it { is_expected.not_to be_able_to :change_rating, answer }
    it { is_expected.not_to be_able_to :cancel, question }
    it { is_expected.not_to be_able_to :cancel, answer }
  end
end
