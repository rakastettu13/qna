require 'rails_helper'

describe 'Answers API', type: :request do
  let(:access_token) { create(:access_token).token }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when access_token is valid' do
      let!(:answer) { create_list(:answer_with_associations, 2, question: question).first }

      before { get api_path, params: { access_token: access_token }, headers: headers }

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      include_examples 'shared fields' do
        let(:answer_json) { json['answers'].first }
        let(:resourse_json) { answer_json }
        let(:resource) { answer }
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/id' do
    let!(:answer) { create_list(:answer_with_associations, 2).first }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when access_token is valid' do
      before { get api_path, params: { access_token: access_token }, headers: headers }

      include_examples 'shared fields' do
        let(:answer_json) { json['answer'] }
        let(:resourse_json) { answer_json }
        let(:resource) { answer }
      end
    end
  end
end
