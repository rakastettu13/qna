class SubscriptionsController < ApplicationController
  include ActionView::Helpers::UrlHelper

  load_and_authorize_resource :question
  load_and_authorize_resource :subscription, through: :question, shallow: true

  def create
    @subscription.user = current_user

    if @subscription.save
      render json: link_to('unsubscribe', question_subscription_path(@question, @subscription),
                           class: 'unsubscribe', method: :delete, remote: true)
    else
      render json: @subscription.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription.destroy

    render json: link_to('subscribe', question_subscriptions_path([@question, @subscription]),
                         class: 'subscribe', method: :post, remote: true)
  end
end
