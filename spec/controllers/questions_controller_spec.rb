require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question: attributes_for(:question) }
      end

      it 'saves a new question in the database' do
        expect { request_for_creation }.to change(Question, :count).by(1)
      end

      it do
        expect(request_for_creation).to redirect_to controller.question
      end
    end

    context 'with invalid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question: attributes_for(:question, :invalid) }
      end

      it 'does not save the question' do
        expect { request_for_creation }.not_to change(Question, :count)
      end

      it { expect(request_for_creation).to render_template :new }
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question) }

    context 'with valid attributes' do
      before do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js

        question.reload
      end

      it { expect(question.title).to eq 'new title' }
      it { expect(question.body).to eq 'new body' }
      it { expect(response).to render_template :update }
    end

    context 'with invalid attributes' do
      subject(:update_request) do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
      end

      it { expect { update_request }.not_to change(question, :title) }
      it { expect { update_request }.not_to change(question, :body) }
      it { expect(update_request).to render_template :update }
    end
  end

  describe 'DELETE #destroy' do
    subject(:deletion_request) { delete :destroy, params: { id: question } }

    context 'when the user is the author' do
      let!(:question) { create(:question, author: user) }

      it 'deletes the question from the database' do
        expect { deletion_request }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        expect(deletion_request).to redirect_to questions_path
      end
    end

    context 'when the user is not the author' do
      let(:another_user) { create(:user) }
      let!(:question) { create(:question, author: another_user) }

      it 'does not delete the question from the database' do
        expect { deletion_request }.not_to change(Question, :count)
      end

      it 'redirects to index' do
        expect(deletion_request).to render_template :show
      end
    end
  end
end
