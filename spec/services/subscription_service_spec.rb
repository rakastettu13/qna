require 'rails_helper'

RSpec.describe SubscriptionService do
  let(:question) { create(:question) }
  let(:subscriber_subscriptions) { create_list(:subscriber_subscription, 3, question: question) }
  let(:answer) { create(:answer, question: question) }
  let(:subscribers) { question.subscribers }

  it 'sends notification to all subscribers' do
    subscribers.each do |_user|
      expect(SubscriptionMailer).to receive(:notification).with(subscribers, answer).and_call_original
    end
    described_class.send_notification(answer)
  end
end
