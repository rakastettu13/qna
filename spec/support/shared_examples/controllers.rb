shared_examples 'response' do |message|
  describe 'response' do
    it { expect(response.header['Content-Type']).to include 'application/json' }
    it { expect(response.body).to include message }
  end
end

shared_examples_for 'destroyable' do
  subject(:request) { delete :destroy, params: { id: id }, format: :js }

  context 'when the user is the author' do
    let!(resource) { create(resource_sym, author: user) }

    it { expect { deletion_request }.to change(resource.class, :count).by(-1) }
    it { is_expected.to render_template :destroy }
  end

  context 'when the user is not the author' do
    let!(resource) { create(resource_sym) }

    it { expect { deletion_request }.not_to change(resource.class, :count) }
  end
end
