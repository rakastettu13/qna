require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) do
    create(:question, author: user, files: [Rack::Test::UploadedFile.new(Rails.root.join('README.md'))])
  end

  describe 'DELETE #destroy' do
    subject(:deletion_request) { delete :destroy, params: { id: question.files.last }, format: :js }

    context 'when the user is the author of resource' do
      before { sign_in(user) }

      it { expect { deletion_request }.to change(question.files, :count).by(-1) }
      it { expect(deletion_request).to render_template :destroy }
    end

    context 'when the user is not the author of resource' do
      before { sign_in(another_user) }

      it { expect { deletion_request }.not_to change(ActiveStorage::Attachment, :count) }
      it { expect(deletion_request).to render_template :destroy }
    end
  end
end
