class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  expose :attachment, -> { ActiveStorage::Attachment.find(params[:id]) }

  def destroy
    attachment.purge if current_user.author_of?(attachment.record)
  end
end
