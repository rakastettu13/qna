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

  describe '#update_best_answer' do
    subject(:update_best_answer_of_question) { question.update_best_answer(another_answer) }

    let(:question) { create(:question) }
    let(:another_answer) { create(:answer, question: question) }

    context 'with best answer' do
      let!(:answer) { create(:answer, question: question, best: true) }

      it 'answer is the best answer' do
        expect(answer).to eql(question.best_answer)
      end

      it 'changes the best answer' do
        expect { update_best_answer_of_question }.to change(question, :best_answer).from(answer).to(another_answer)
      end

      it 'another answer is the best answer' do
        update_best_answer_of_question
        expect(another_answer).to eql(question.best_answer)
      end
    end

    context 'without best answer' do
      it 'the best answer is nil' do
        expect(question.best_answer).to be_nil
      end

      it 'sets the best answer' do
        expect { update_best_answer_of_question }.to change(question, :best_answer).from(nil).to(another_answer)
      end

      it 'the best answer is given' do
        update_best_answer_of_question
        expect(another_answer).to eql(question.best_answer)
      end
    end
  end
end
