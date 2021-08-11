require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'with question' do
    it { is_expected.to belong_to :question }
  end

  context 'with author' do
    it { is_expected.to belong_to(:author).class_name('User') }
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of :body }
  end
end
