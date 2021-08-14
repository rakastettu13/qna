require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'with answers' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
  end

  context 'with author' do
    it { is_expected.to belong_to(:author).class_name('User') }
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
  end

  describe '#best_answer' do
    subject { answer }

    let(:question) { create(:question) }

    context 'with best answer' do
      let(:answer) { create(:answer, question: question, best: true) }

      it { is_expected.to eql(question.best_answer) }
    end

    context 'without best answer' do
      let(:answer) { create(:answer, question: question) }

      it { is_expected.not_to eql(question.best_answer) }
    end
  end
end
