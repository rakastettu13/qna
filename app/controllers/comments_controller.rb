class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create

  load_resource :question
  load_resource :answer
  load_and_authorize_resource :comment, through: %i[question answer]

  before_action :gon_variables, only: :create
  after_action :publish_comment, only: :create

  expose :resource, -> { @comment.commentable }
  expose :comment, -> { @comment }

  def create
    comment.author = current_user
    render json: comment.errors.full_messages, status: :unprocessable_entity unless comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return unless comment.persisted?

    ActionCable.server.broadcast("questions/#{gon.question_id}",
                                 { css: "#{resource.class}-#{resource.id} .comments".downcase,
                                   template: ApplicationController.render(partial: 'comments/comment',
                                                                          locals: { comment: comment }) })
  end

  def gon_variables
    gon.question_id = if resource.instance_of?(Question)
                        resource.id
                      else
                        resource.question.id
                      end
  end
end
