require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject { build(:vote, :for_question) }

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :votable }

  it { is_expected.to validate_uniqueness_of(:user).scoped_to(%i[votable_id votable_type]) }

  it do
    is_expected.to validate_numericality_of(:point).only_integer
                                                   .is_greater_than_or_equal_to(-1)
                                                   .is_less_than_or_equal_to(1)
  end

  describe '#errors' do
    subject { vote.errors.full_messages }

    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    before { vote.validate }

    context 'when the user is the author of the votable' do
      let(:vote) { build(:vote, :for_question, votable: question, user: user) }

      it { is_expected.to include 'User cannot be the author of votable' }
    end

    context 'when the user is not the author of the votable' do
      let(:vote) { create(:vote, :for_question, votable: question) }

      it { is_expected.not_to include 'User cannot be the author of votable' }
    end
  end
end
