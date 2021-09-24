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
      let!(:question) { create_list(:question_with_associations, 2).first }
      let!(:answer) { create_list(:answer, 2, question: question).first }

      before { get api_path, params: { access_token: access_token }, headers: headers }

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      include_examples 'question fields' do
        let(:resource) { question }
        let(:resourse_json) { json['questions'].first }
        let(:answer_json) { resourse_json['answers'].first }
      end
    end
  end

  describe 'GET /api/v1/questions/id' do
    let(:question) { create(:question_with_associations) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when access_token is valid' do
      let!(:answer) { create_list(:answer, 2, question: question).first }

      before { get api_path, params: { access_token: access_token }, headers: headers }

      include_examples 'question fields' do
        let(:resource) { question }
        let(:resourse_json) { json['question'] }
        let(:answer_json) { resourse_json['answers'].first }
      end
    end
  end
end
