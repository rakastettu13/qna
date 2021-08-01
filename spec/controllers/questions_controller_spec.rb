require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it { is_expected.to render_template :index }
  end

  describe 'GET #show' do
    subject(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns @question to @answer.question' do
      expect(assigns(:answer).question).to eq question
    end

    it { is_expected.to render_template :show }
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it { is_expected.to render_template :new }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      subject(:request_for_creation) { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new question in the database' do
        expect { request_for_creation }.to change(Question, :count).by(1)
      end

      it do
        expect(request_for_creation).to redirect_to assigns(:question)
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
