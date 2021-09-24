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
