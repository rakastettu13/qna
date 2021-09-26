require 'rails_helper'

describe 'Answers API', type: :request do
  describe 'GET api/v1/answers#index' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    describe 'when access_token is valid' do
      let(:access_token) { create(:access_token).token }
      let!(:resource) { create_list(:answer_with_associations, 2, question: question).first }
      let(:resource_json) { json['answers'].first }

      before { get api_path, params: { access_token: access_token } }

      it { expect(response).to be_successful }

      include_examples 'answers fields' do
        let(:answer) { resource }
        let(:answers_json) { json['answers'] }
        let(:answer_json) { resource_json }
      end
      include_examples 'shared fields'
    end
  end

  describe 'GET api/v1/answers#show' do
    let!(:resource) { create_list(:answer_with_associations, 2).first }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    describe 'when access_token is valid' do
      let(:access_token) { create(:access_token).token }
      let(:resource_json) { json['answer'] }

      before { get api_path, params: { access_token: access_token } }

      it { expect(response).to be_successful }

      include_examples 'answer fields' do
        let(:answer) { resource }
        let(:answer_json) { resource_json }
      end
      include_examples 'shared fields'
    end
  end

  describe 'POST api/v1/answers#create' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end
    it_behaves_like 'API creatable', :answer, Answer, ['body']
  end

  describe 'PATH api/v1/answers#update' do
    let(:user) { create(:user) }
    let(:resource) { create(:answer, author: user) }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end
    it_behaves_like 'API updatable' do
      let(:resource_json) { json['answer'] }
    end
  end

  describe 'DELETE api/v1/answers#destroy' do
    let(:user) { create(:user) }
    let!(:resource) { create(:answer, author: user) }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end
    it_behaves_like 'API destroyable'
  end
end
