module QuestionsHelper
  def subscription_links(question, subscription)
    return unless current_user

    if can? :destroy, subscription
      link_to 'unsubscribe', question_subscription_path(question, subscription),
              class: 'unsubscribe', method: :delete, remote: true
    else
      link_to 'subscribe', question_subscriptions_path([question, subscription]),
              class: 'subscribe', method: :post, remote: true
    end
  end
end
