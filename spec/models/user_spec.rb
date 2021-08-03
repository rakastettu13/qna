require 'rails_helper'

RSpec.describe User, type: :model do
  context 'with questions' do
    it { is_expected.to have_many(:questions).dependent(:destroy) }
  end

  context 'with answers' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
  end
end
