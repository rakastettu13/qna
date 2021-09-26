require 'rails_helper'

describe 'Profiles API', type: :request do
  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when access_token is valid' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id).token }

      before { get api_path, params: { access_token: access_token } }

      it { expect(response).to be_successful }

      include_examples 'user fields' do
        let(:user_json) { json['user'] }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when access_token is valid' do
      let(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: users.first.id).token }

      before { get api_path, params: { access_token: access_token } }

      it { expect(response).to be_successful }

      it 'returns list of users without current user' do
        expect(json['users'].size).to eq 2
      end

      include_examples 'user fields' do
        let(:user) { users.last }
        let(:user_json) { json['users'].last }
      end
    end
  end
end
