require 'rails_helper'

describe 'Questions API', type: :request do
  describe 'GET api/v1/questions#index' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    describe 'when access_token is valid' do
      let(:access_token) { create(:access_token).token }
      let!(:resource) { create_list(:question_with_associations, 2).first }
      let!(:answer) { create_list(:answer, 2, question: resource).first }
      let(:resource_json) { json['questions'].first }

      before { get api_path, params: { access_token: access_token } }

      it { expect(response).to be_successful }

      include_examples 'questions fields'
      include_examples 'answers fields' do
        let(:answers_json) { resource_json['answers'] }
        let(:answer_json) { resource_json['answers'].first }
      end
      include_examples 'shared fields'
    end
  end

  describe 'GET api/v1/questions#show' do
    let(:resource) { create(:question_with_associations) }
    let!(:answer) { create_list(:answer, 2, question: resource).first }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    describe 'when access_token is valid' do
      let(:access_token) { create(:access_token).token }
      let(:resource_json) { json['question'] }

      before { get api_path, params: { access_token: access_token } }

      it { expect(response).to be_successful }

      include_examples 'question fields'
      include_examples 'answers fields' do
        let(:answers_json) { resource_json['answers'] }
        let(:answer_json) { resource_json['answers'].first }
      end
      include_examples 'shared fields'
    end
  end

  describe 'POST api/v1/questions#create' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end
    it_behaves_like 'API creatable', :question, Question, %w[title body]
  end

  describe 'PATH api/v1/questions#update' do
    let(:user) { create(:user) }
    let(:resource) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end
    it_behaves_like 'API updatable' do
      let(:resource_json) { json['question'] }
    end
  end

  describe 'DELETE api/v1/questions#destroy' do
    let(:user) { create(:user) }
    let!(:resource) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end
    it_behaves_like 'API destroyable'
  end
end
