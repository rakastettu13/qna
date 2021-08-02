require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      subject(:request_for_creation) { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new question in the database' do
        expect { request_for_creation }.to change(Question, :count).by(1)
      end

      it do
        expect(request_for_creation).to redirect_to controller.question
      end
    end

    context 'with invalid attributes' do
      subject(:request_for_creation) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it 'does not save the question' do
        expect { request_for_creation }.not_to change(Question, :count)
      end

      it { expect(request_for_creation).to render_template :new }
    end
  end
end
