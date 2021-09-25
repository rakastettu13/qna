require 'rails_helper'

RSpec.describe Answer, type: :model do
  include_examples 'shared associations'

  it { is_expected.to belong_to :question }

  include_examples 'shared methods', :answer, :answer_with_votes

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
end
