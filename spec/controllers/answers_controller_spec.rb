require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  let(:question) { create(:question) }

  before { sign_in(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js
      end

      it 'saves a new answer with a foreign key to the question in the database' do
        expect { request_for_creation }.to change(question.answers, :count).by(1)
      end

      it { expect(request_for_creation).to render_template :create }
    end

    context 'with invalid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js
      end

      it 'does not save the answer' do
        expect { request_for_creation }.not_to change(Answer, :count)
      end

      it { expect(request_for_creation).to render_template :create }
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, body: 'answer body', question: question, author: user) }

    context 'when author tries to update the answer with valid attributes' do
      before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

      it do
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it { expect(response).to render_template :update }
    end

    context 'when author tries to update the answer with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

      it do
        answer.reload
        expect(answer.body).to eq 'answer body'
      end

      it { expect(response).to render_template :update }
    end

    context 'when another user tries to update the answer' do
      let(:answer) { create(:answer, body: 'answer body', question: question, author: another_user) }

      before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

      it do
        answer.reload
        expect(answer.body).to eq 'answer body'
      end

      it { expect(response).to render_template :update }
    end
  end

  describe 'DELETE #destroy' do
    subject(:deletion_request) { delete :destroy, params: { id: answer }, format: :js }

    context 'when the user is the author' do
      let!(:answer) { create(:answer, author: user, question: question) }

      it { expect { deletion_request }.to change(Answer, :count).by(-1) }
      it { expect(deletion_request).to render_template :destroy }
    end

    context 'when the user is not the author' do
      let!(:answer) { create(:answer, author: another_user, question: question) }

      it { expect { deletion_request }.not_to change(Answer, :count) }
      it { expect(deletion_request).to render_template :destroy }
    end
  end

  describe 'PATCH #best' do
    before { patch :best, params: { id: answer }, format: :js }

    context 'when the user is the author of question' do
      let!(:question) { create(:question, author: user) }
      let!(:answer) { create(:answer, question: question) }

      it do
        answer.reload
        expect(answer.best).to be_truthy
      end

      it { expect(response).to render_template :best }
    end

    context 'when the user is not the author of question' do
      let!(:answer) { create(:answer, question: question) }

      it do
        answer.reload
        expect(answer.best).to be_falsy
      end

      it { expect(response).to render_template :best }
    end
  end
end
