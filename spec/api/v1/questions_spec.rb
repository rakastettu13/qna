require 'rails_helper'

describe 'Questions API', type: :request do
  let(:access_token) { create(:access_token).token }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when access_token is valid' do
      let(:questions) { create_list(:question_with_attachments, 2) }
      let!(:answer) { create_list(:answer, 2, question: question).first }
      let!(:comment) { create_list(:comment, 2, :for_question, commentable: question).first }
      let!(:link) { create_list(:link, 2, :for_question, linkable: question).first }

      before { get api_path, params: { access_token: access_token }, headers: headers }

      it { expect(response).to be_successful }

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      include_examples 'question api' do
        let(:question) { questions.first }
        let(:question_json) { json['questions'].first }
      end
    end
  end

  describe 'GET /api/v1/questions/id' do
    let(:question) { create(:question_with_attachments) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when access_token is valid' do
      let!(:answer) { create_list(:answer, 2, question: question).first }
      let!(:comment) { create_list(:comment, 2, :for_question, commentable: question).first }
      let!(:link) { create_list(:link, 2, :for_question, linkable: question).first }

      before { get api_path, params: { access_token: access_token }, headers: headers }

      it { expect(response).to be_successful }

      include_examples 'question api' do
        let(:question_json) { json['question'] }
      end
    end
  end
end
