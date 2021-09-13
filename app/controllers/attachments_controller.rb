class AttachmentsController < ApplicationController
  load_and_authorize_resource class: ActiveStorage::Attachment

  def destroy
    @attachment.purge
  end
end
