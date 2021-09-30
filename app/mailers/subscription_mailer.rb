class SubscriptionMailer < ApplicationMailer
  def notification(user, answer)
    @answer = answer

    mail to: user.email
  end
end
