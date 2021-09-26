require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:resource) { create(:question) }

    before { sign_in(user) }

    context 'with valid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question_id: resource.id, comment: { body: 'Comment body', commentable: resource } },
                      format: :js
      end

      it { expect { request_for_creation }.to change(resource.comments, :count).by(1) }
      it { expect { request_for_creation }.to have_broadcasted_to("questions/#{resource.id}") }
    end

    context 'with invalid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question_id: resource.id, comment: { body: '', commentable: resource } }, format: :js
      end

      it { expect { request_for_creation }.not_to change(resource.class, :count) }
      it { expect { request_for_creation }.not_to have_broadcasted_to("questions/#{resource.id}") }

      include_examples 'response', "Body can't be blank" do
        before { request_for_creation }
      end
    end
  end
end
