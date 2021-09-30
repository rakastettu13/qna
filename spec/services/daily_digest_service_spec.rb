require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 3) }
  let(:questions) { create_list(:questions, 3) }

  it 'sends daily digest to all users' do
    User.find_each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions).and_call_original }
    described_class.send_digest
  end
end
