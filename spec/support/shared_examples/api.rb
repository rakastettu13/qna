shared_examples_for 'API authorizable' do
  context 'when there is no access_token' do
    before { do_request(method, api_path, headers: headers) }

    it { expect(response).to be_unauthorized }
  end

  context 'when access_token is invalid' do
    before { do_request(method, api_path, params: { access_token: '1234' }, headers: headers) }

    it { expect(response).to be_unauthorized }
  end
end

shared_examples 'user fields' do
  it 'returns all public fields for user' do
    %w[id email admin created_at updated_at].each do |attr|
      expect(user_json[attr]).to eq user.send(attr).as_json
    end
  end

  it 'does not return private fields for user' do
    %w[password encrypted_password].each do |attr|
      expect(user_json).not_to have_key(attr)
    end
  end
end
