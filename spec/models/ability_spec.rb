require 'rails_helper'
require 'cancan/matchers'

RSpec.shared_examples 'read, create' do |verb|
  it { is_expected.send verb, be_able_to(:received, Achievement) }
  it { is_expected.send verb, be_able_to(:create, Question) }
  it { is_expected.send verb, be_able_to(:create, Answer) }
  it { is_expected.send verb, be_able_to(:create, Comment) }
end

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    include_examples 'read, create', :not_to

    it { is_expected.to be_able_to :read, :all }
    it { is_expected.not_to be_able_to %i[create update destroy], Question }
    it { is_expected.not_to be_able_to %i[create update destroy], Answer }
    it { is_expected.not_to be_able_to %i[destroy], ActiveStorage::Attachment }
    it { is_expected.not_to be_able_to :change_rating, Question }
    it { is_expected.not_to be_able_to :change_rating, Answer }
    it { is_expected.not_to be_able_to :best, Answer }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }

    include_examples 'read, create', :to

    it { is_expected.to be_able_to :read, :all }
    it { is_expected.not_to be_able_to :best, answer }
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
    let(:question_answer) { create(:answer, author: user, question: question) }
    let(:attachment) { create(:question_with_attachments, author: user).files.last }

    include_examples 'read, create', :to

    it { is_expected.to be_able_to :read, :all }
    it { is_expected.to be_able_to :best, question_answer }
    it { is_expected.not_to be_able_to :best, answer }
    it { is_expected.to be_able_to %i[update destroy], question }
    it { is_expected.to be_able_to %i[update destroy], answer }
    it { is_expected.to be_able_to %i[destroy], attachment }
    it { is_expected.not_to be_able_to :change_rating, question }
    it { is_expected.not_to be_able_to :change_rating, answer }
    it { is_expected.not_to be_able_to :cancel, question }
    it { is_expected.not_to be_able_to :cancel, answer }
  end
end
