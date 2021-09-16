require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'DELETE #destroy' do
    subject(:deletion_request) { delete :destroy, params: { id: question.files.last }, format: :js }

    context 'when the user is the author of resource' do
      let!(:question) { create(:question_with_attachments, author: user) }

      it { expect { deletion_request }.to change(question.files, :count).by(-1) }
      it { expect(deletion_request).to render_template :destroy }
    end

    context 'when the user is not the author of resource' do
      let!(:question) { create(:question_with_attachments) }

      it { expect { deletion_request }.not_to change(ActiveStorage::Attachment, :count) }
    end
  end
end
