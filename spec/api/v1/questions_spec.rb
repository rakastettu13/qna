require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    context 'when there is no access_token' do
      before { get '/api/v1/questions', headers: headers }

      it { expect(response).to be_unauthorized }
    end

    context 'when access_token is invalid' do
      before { get '/api/v1/questions', params: { access_token: '1234' }, headers: headers }

      it { expect(response).to be_unauthorized }
    end

    context 'when access_token is valid' do
      let(:access_token) { create(:access_token).token }
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let(:question_json) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token }, headers: headers }

      it { expect(response).to be_successful }

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'user' do
        let(:user) { question.author }
        let(:user_json) { question_json['author'] }

        it 'returns all public fields' do
          %w[id email admin created_at updated_at].each do |attr|
            expect(user_json[attr]).to eq user.send(attr).as_json
          end
        end

        it 'does not return private fields' do
          %w[password encrypted_password].each do |attr|
            expect(user_json).not_to have_key(attr)
          end
        end
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_json) { question_json['answers'].first }

        it 'returns list of answers' do
          expect(question_json['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body best question_id author_id created_at updated_at].each do |attr|
            expect(answer_json[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end
