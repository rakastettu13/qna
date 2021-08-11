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
end
