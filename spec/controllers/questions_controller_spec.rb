require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET #new' do
    before { get :new }

    it 'builds link to question.links' do
      expect(controller.question.links.first).to be_a_new(Link)
    end

    it 'builds achievement to question' do
      expect(controller.question.achievement).to be_a_new(Achievement)
    end

    it { is_expected.to render_template :new }
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'builds link to new answer' do
      expect(controller.answer.links.first).to be_a_new(Link)
    end

    it { is_expected.to render_template :show }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      subject(:request_for_creation) { post :create, params: { question: attributes_for(:question) } }

      it { expect { request_for_creation }.to change(Question, :count).by(1) }
      it { is_expected.to redirect_to controller.question }
    end

    context 'with invalid attributes' do
      subject(:request_for_creation) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it { expect { request_for_creation }.not_to change(Question, :count) }
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
      it { is_expected.to render_template :update }
    end

    context 'when the user is not the author' do
      let(:question) { create(:question, title: 'title', body: 'body') }

      before do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
      end

      it { expect { question.reload }.not_to change(question, :title) }
      it { expect { question.reload }.not_to change(question, :body) }
      it { is_expected.to render_template :update }
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
      it { is_expected.to render_template :show }
    end
  end

  describe 'PATCH #increase' do
    subject(:increase) { patch :increase_rating, params: { id: question }, format: :json }

    let(:question) { create(:question) }

    it { expect { increase }.to change(question, :rating).by(1) }

    describe 'response' do
      before { increase }

      it { expect(response.header['Content-Type']).to include 'application/json' }
      it { expect(response.body).to include question.rating.to_s }
    end
  end

  describe 'PATCH #decrease' do
    subject(:decrease) { patch :decrease_rating, params: { id: question }, format: :json }

    let(:question) { create(:question) }

    it { expect { decrease }.to change(question, :rating).by(-1) }

    describe 'response' do
      before { decrease }

      it { expect(response.header['Content-Type']).to include 'application/json' }
      it { expect(response.body).to include question.rating.to_s }
    end
  end
end
