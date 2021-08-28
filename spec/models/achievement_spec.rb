require 'rails_helper'

RSpec.describe Achievement, type: :model do
  it { is_expected.to belong_to(:winner).class_name('User').optional }
  it { is_expected.to belong_to(:question) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :image }

  describe '#image' do
    subject { described_class.new.image }

    it { is_expected.to be_an_instance_of(ActiveStorage::Attached::One) }
  end
end
