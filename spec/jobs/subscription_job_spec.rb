require 'rails_helper'

RSpec.describe SubscriptionJob, type: :job do
  let(:answer) { create(:answer) }

  it 'calls SubscriptionService#send_notification' do
    expect(SubscriptionService).to receive(:send_notification).with(answer)
    described_class.perform_now(answer)
  end
end
