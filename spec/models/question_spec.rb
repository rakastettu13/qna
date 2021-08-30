require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to belong_to(:author).class_name('User') }

  it { is_expected.to have_one(:achievement).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for(:links).allow_destroy(true) }
  it { is_expected.to accept_nested_attributes_for(:achievement) }

  describe '#files' do
    subject { described_class.new.files }

    it { is_expected.to be_an_instance_of(ActiveStorage::Attached::Many) }
  end

  describe '#best_answer' do
    subject { question.best_answer }

    let(:question) { create(:question_with_answers) }

    context 'when the best answer exists' do
      let!(:best_answer) { create(:answer, question: question, best: true) }

      it { is_expected.to eql(best_answer) }
    end

    context 'when the best answer does not exist' do
      it { is_expected.to be_nil }
    end
  end

  describe '#update_best_answer' do
    subject(:update_best_answer_of_question) { question.update_best_answer(another_answer) }

    let(:question) { create(:question) }
    let(:another_answer) { create(:answer, question: question) }

    context 'when the best answer exists' do
      let(:answer) { create(:answer, question: question, best: true) }

      it { expect { update_best_answer_of_question }.to change(question, :best_answer).from(answer).to(another_answer) }
    end

    context 'when the best answer does not exist' do
      it { expect { update_best_answer_of_question }.to change(question, :best_answer).from(nil).to(another_answer) }
    end

    context 'when an achievement for the best answer was added' do
      let!(:achievement) { create(:achievement, question: question) }

      it { expect { update_best_answer_of_question }.to change(achievement, :winner).to(another_answer.author) }
    end
  end

  describe '#rating' do
    subject { question.rating }

    context 'with votes' do
      let(:question) { create(:question_with_votes) }

      it { is_expected.to be question.votes.sum(:point) }
    end

    context 'without votes' do
      let(:question) { create(:question) }

      it { is_expected.to be_zero }
    end
  end
end
