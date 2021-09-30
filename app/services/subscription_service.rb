class SubscriptionService
  def self.send_notification(answer)
    answer.question.subscribers.each { |user| SubscriptionMailer.notification(user, answer).deliver_later }
  end
end
