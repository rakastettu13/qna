shared_examples_for 'API creatable' do |resource, resource_class, resourse_attrs|
  let(:access_token) { create(:access_token).token }

  context 'with valid attributes' do
    let(:request) do
      post api_path, params: { access_token: access_token, resource => attributes_for(resource) }
    end

    it do
      request
      expect(response).to be_successful
    end

    it { expect { request }.to change(resource_class, :count).by(1) }

    it 'assigns params to the resource' do
      request
      resourse_attrs.each do |attr|
        expect(json[resource.to_s][attr]).to eq attributes_for(resource)[attr.to_sym]
      end
    end
  end

  context 'with invalid attributes' do
    let(:request) do
      post api_path, params: { access_token: access_token, resource => attributes_for(resource, :invalid) }
    end

    it do
      request
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it { expect { request }.not_to change(resource_class, :count) }
  end
end

shared_examples_for 'API updatable' do
  context 'when access_token is valid' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id).token }
    let(:resource_params) { resource.class.name.downcase }

    context 'with valid attributes' do
      before do
        patch api_path, params: { access_token: access_token,
                                  resource_params => { body: 'new body' } }
      end

      it { expect(response).to be_successful }
      it { expect { resource.reload }.to change(resource, :body).to('new body') }

      it 'assigns new params to the resource' do
        expect(resource_json['body']).to eq 'new body'
      end
    end

    context 'with invalid attributes' do
      before do
        patch api_path, params: { access_token: access_token, resource_params => { body: '' } }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect { resource.reload }.not_to change(resource, :body) }
    end
  end
end

shared_examples_for 'API destroyable' do
  context 'when access_token is valid' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id).token }

    let(:request) { delete api_path, params: { access_token: access_token } }

    it do
      request
      expect(response).to be_no_content
    end

    it { expect { request }.to change(resource.class, :count).by(-1) }
  end
end
