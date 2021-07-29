require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  subject(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns @question to @answer.question' do
      expect(assigns(:answer).question).to eq question
    end

    it { is_expected.to render_template :new }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
      end

      it 'saves a new answer with a foreign key to the question in the database' do
        expect { request_for_creation }.to change(question.answers, :count).by(1)
      end

      it do
        expect(request_for_creation).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      subject(:request_for_creation) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
      end

      it 'does not save the answer' do
        expect { request_for_creation }.not_to change(Answer, :count)
      end

      it { expect(request_for_creation).to render_template :new }
    end
  end
end
