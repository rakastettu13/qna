class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    SubscriptionService.send_notification(answer)
  end
end
