require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    subject(:user) { create(:user) }

    let(:question) { create(:question) }

    before { sign_in(user) }

    context 'with valid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
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
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
      end

      it 'does not save the answer' do
        expect { request_for_creation }.not_to change(Answer, :count)
      end

      it { expect(request_for_creation).to render_template 'questions/show' }
    end
  end
end
