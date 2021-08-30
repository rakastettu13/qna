require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :votable }

  it do
    is_expected.to validate_numericality_of(:point).only_integer
                                                   .is_greater_than_or_equal_to(-1)
                                                   .is_less_than_or_equal_to(1)
  end
end
