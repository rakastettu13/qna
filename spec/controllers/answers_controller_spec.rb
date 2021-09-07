require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  include_examples 'voting', :answer

  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'with valid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js
      end

      it { expect { request_for_creation }.to change(question.answers, :count).by(1) }
      it { expect { request_for_creation }.to have_broadcasted_to("questions/#{question.id}") }
      it { is_expected.to render_template :create }
    end

    context 'with invalid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js
      end

      it { expect { request_for_creation }.not_to change(Answer, :count) }
      it { expect { request_for_creation }.not_to have_broadcasted_to("questions/#{question.id}") }
      it { is_expected.to render_template :create }
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes when the user is the author' do
      let(:answer) { create(:answer, body: 'body', author: user) }

      before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

      it { expect { answer.reload }.to change(answer, :body).from('body').to('new body') }
      it { is_expected.to render_template :update }
    end

    context 'with invalid attributes when the user is the author' do
      let(:answer) { create(:answer, body: 'body', author: user) }

      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

      it { expect { answer.reload }.not_to change(answer, :body) }
      it { is_expected.to render_template :update }
    end

    context 'when the user is not the author' do
      let(:answer) { create(:answer, body: 'body') }

      before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

      it { expect { answer.reload }.not_to change(answer, :body) }
      it { expect(response).to render_template :update }
    end
  end

  describe 'DELETE #destroy' do
    subject(:deletion_request) { delete :destroy, params: { id: answer }, format: :js }

    context 'when the user is the author' do
      let!(:answer) { create(:answer, author: user) }

      it { expect { deletion_request }.to change(Answer, :count).by(-1) }
      it { is_expected.to render_template :destroy }
    end

    context 'when the user is not the author' do
      let!(:answer) { create(:answer) }

      it { expect { deletion_request }.not_to change(Answer, :count) }
      it { is_expected.to render_template :destroy }
    end
  end

  describe 'PATCH #best' do
    before { patch :best, params: { id: answer }, format: :js }

    context 'when the user is the author of question' do
      let!(:question) { create(:question, author: user) }
      let!(:answer) { create(:answer, question: question) }

      it { expect { answer.reload }.to change(answer, :best).from(false).to(true) }
      it { is_expected.to render_template :best }
    end

    context 'when the user is not the author of question' do
      let!(:answer) { create(:answer) }

      it { expect { answer.reload }.not_to change(answer, :best) }
      it { is_expected.to render_template :best }
    end
  end
end
