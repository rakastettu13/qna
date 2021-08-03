require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }

  let(:question) { create(:question) }

  before { sign_in(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question_id: question.id,
                                author_id: user.id,
                                answer: attributes_for(:answer) }
      end

      it 'saves a new answer with a foreign key to the question in the database' do
        expect { request_for_creation }.to change(question.answers, :count).by(1)
      end

      it do
        expect(request_for_creation).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question_id: question.id,
                                author_id: user.id,
                                answer: attributes_for(:answer, :invalid) }
      end

      it 'does not save the answer' do
        expect { request_for_creation }.not_to change(Answer, :count)
      end

      it { expect(request_for_creation).to render_template 'questions/show' }
    end
  end

  describe 'DELETE #destroy' do
    subject(:deletion_request) { delete :destroy, params: { id: answer } }

    context 'when the user is the author' do
      let!(:answer) { create(:answer, author: user, question: question) }

      it 'deletes the question from the database' do
        expect { deletion_request }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        expect(deletion_request).to redirect_to question
      end
    end

    context 'when the user is not the author' do
      let(:another_user) { create(:user) }
      let!(:answer) { create(:answer, author: another_user, question: question) }

      it 'does not delete the question from the database' do
        expect { deletion_request }.not_to change(Answer, :count)
      end

      it 'redirects to index' do
        expect(deletion_request).to render_template 'questions/show'
      end
    end
  end
end
