require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  it_behaves_like 'Votable', :question

  describe 'GET #new' do
    before { get :new }

    it 'builds achievement to question' do
      expect(assigns(:question).achievement).to be_a_new(Achievement)
    end

    it { is_expected.to render_template :new }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      subject(:request_for_creation) { post :create, params: { question: attributes_for(:question) } }

      it { expect { request_for_creation }.to change(Question, :count).by(1) }
      it { expect { request_for_creation }.to have_broadcasted_to('questions') }
      it { is_expected.to redirect_to assigns(:question) }

      it 'subscribed current user on this question' do
        request_for_creation

        expect(assigns(:question).subscribers).to include user
      end
    end

    context 'with invalid attributes' do
      subject(:request_for_creation) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it { expect { request_for_creation }.not_to change(Question, :count) }
      it { expect { request_for_creation }.not_to have_broadcasted_to('questions') }
      it { is_expected.to render_template :new }
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes when the user is the author' do
      let(:question) { create(:question, author: user, title: 'title', body: 'body') }

      before do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
      end

      it { expect { question.reload }.to change(question, :title).from('title').to('new title') }
      it { expect { question.reload }.to change(question, :body).from('body').to('new body') }
      it { is_expected.to render_template :update }
    end

    context 'with invalid attributes when the user is the author' do
      let(:question) { create(:question, author: user, title: 'title', body: 'body') }

      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it { expect { question.reload }.not_to change(question, :title) }
      it { expect { question.reload }.not_to change(question, :body) }

      include_examples 'response', "Title can't be blank"
    end

    context 'when the user is not the author' do
      let(:question) { create(:question, title: 'title', body: 'body') }

      before do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
      end

      it { expect { question.reload }.not_to change(question, :title) }
      it { expect { question.reload }.not_to change(question, :body) }
    end
  end

  describe 'DELETE #destroy' do
    subject(:deletion_request) { delete :destroy, params: { id: question } }

    context 'when the user is the author' do
      let!(:question) { create(:question, author: user) }

      it { expect { deletion_request }.to change(Question, :count).by(-1) }
      it { is_expected.to redirect_to questions_path }
    end

    context 'when the user is not the author' do
      let!(:question) { create(:question) }

      it { expect { deletion_request }.not_to change(Question, :count) }
    end
  end
end
