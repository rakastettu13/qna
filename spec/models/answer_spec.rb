require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :question }
    it { is_expected.to belong_to(:author).class_name('User') }

    it 'is expected to have many attached files' do
      expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of :body }
  end

  describe '#best' do
    subject(:answer) { build(:answer, best: true) }

    context 'when true' do
      before { allow(answer).to receive(:best).and_return(true) }

      it { is_expected.to validate_uniqueness_of(:best).scoped_to(:question_id) }
    end

    context 'when false' do
      before { allow(answer).to receive(:best).and_return(false) }

      it { is_expected.not_to validate_uniqueness_of(:best).scoped_to(:question_id) }
    end
  end
end
