class DailyDigestService
  def self.send_digest
    questions = Question.where('created_at > ?', 24.hours.ago)

    User.find_each { |user| DailyDigestMailer.digest(user, questions).deliver_later }
  end
end
