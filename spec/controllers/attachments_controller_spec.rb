require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'DELETE #destroy' do
    subject(:deletion_request) { delete :destroy, params: { id: question.files.last }, format: :js }

    context 'when the user is the author of resource' do
      let!(:question) do
        create(:question, author: user, files: [Rack::Test::UploadedFile.new(Rails.root.join('README.md'))])
      end

      it { expect { deletion_request }.to change(question.files, :count).by(-1) }
      it { expect(deletion_request).to render_template :destroy }
    end

    context 'when the user is not the author of resource' do
      let!(:question) { create(:question, files: [Rack::Test::UploadedFile.new(Rails.root.join('README.md'))]) }

      it { expect { deletion_request }.not_to change(ActiveStorage::Attachment, :count) }
      it { expect(deletion_request).to render_template :destroy }
    end
  end
end
