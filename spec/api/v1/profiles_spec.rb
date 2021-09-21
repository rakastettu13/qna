require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    context 'when there is no access_token' do
      before { get '/api/v1/profiles/me', headers: headers }

      it { expect(response).to be_unauthorized }
    end

    context 'when access_token is invalid' do
      before { get '/api/v1/profiles/me', params: { access_token: '1234' }, headers: headers }

      it { expect(response).to be_unauthorized }
    end

    context 'when access_token is valid' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id).token }

      before { get '/api/v1/profiles/me', params: { access_token: access_token }, headers: headers }

      it { expect(response).to be_successful }

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).not_to have_key(attr)
        end
      end
    end
  end
end
