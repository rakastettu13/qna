class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create

  load_resource :question
  load_resource :answer
  load_and_authorize_resource :comment, through: %i[question answer]

  def create
    @comment.author = current_user

    if @comment.save
      publish_comment
    else
      render_errors(@comment)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    ActionCable.server.broadcast("questions/#{question_id}",
                                 { css: "#{resource.class}-#{resource.id} .comments".downcase,
                                   template: ApplicationController.render(partial: 'comments/comment',
                                                                          locals: { comment: @comment }) })
  end

  def question_id
    if resource.instance_of?(Question)
      resource.id
    else
      resource.question.id
    end
  end

  def resource
    @comment.commentable
  end
end
