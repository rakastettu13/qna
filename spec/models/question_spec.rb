require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'with associations' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
  end
end
