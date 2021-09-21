require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when access_token is valid' do
      let(:access_token) { create(:access_token).token }
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let(:question_json) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }
      let(:answer_json) { question_json['answers'].first }

      before { get api_path, params: { access_token: access_token }, headers: headers }

      it { expect(response).to be_successful }

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 3
      end

      it 'returns all public fields for question' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end

      include_examples 'user fields' do
        let(:user) { question.author }
        let(:user_json) { question_json['author'] }
      end

      it 'returns list of answers' do
        expect(question_json['answers'].size).to eq 3
      end

      it 'returns all public fields for answers' do
        %w[id body best question_id author_id created_at updated_at].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end
end
