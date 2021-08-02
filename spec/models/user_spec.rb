require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'has questions' do
    it { is_expected.to have_many(:questions).dependent(:destroy) }
  end

  describe 'has answers' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
  end
end
