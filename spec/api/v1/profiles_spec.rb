require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when access_token is valid' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id).token }

      before { get api_path, params: { access_token: access_token }, headers: headers }

      it { expect(response).to be_successful }

      include_examples 'user fields' do
        let(:user_json) { json['user'] }
      end
    end
  end
end
