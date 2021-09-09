require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to :question }
  it { is_expected.to belong_to(:author).class_name('User') }
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for(:links).allow_destroy(true) }

  it { is_expected.to validate_presence_of :body }

  describe '#files' do
    it { expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many) }
  end

  describe '#best' do
    subject(:answer) { build(:answer, best: true) }

    context 'when the answer is the best' do
      before { allow(answer).to receive(:best).and_return(true) }

      it { is_expected.to validate_uniqueness_of(:best).scoped_to(:question_id) }
    end

    context 'when the answer is not the best' do
      before { allow(answer).to receive(:best).and_return(false) }

      it { is_expected.not_to validate_uniqueness_of(:best).scoped_to(:question_id) }
    end
  end

  describe '#rating' do
    subject { answer.rating }

    context 'with votes' do
      let(:answer) { create(:answer_with_votes) }

      it { is_expected.to be answer.votes.sum(:point) }
    end

    context 'without votes' do
      let(:answer) { create(:answer) }

      it { is_expected.to be_zero }
    end
  end
end
