RSpec.shared_examples 'voting' do |votable|
  describe 'PATCH #increase_rating' do
    subject(:increase) { patch :increase_rating, params: { id: resource }, format: :json }

    context 'when the user is the author' do
      let(:resource) { create(votable, author: user) }

      it { expect { increase }.not_to change(resource, :rating) }

      describe 'response' do
        before { increase }

        it { expect(response.header['Content-Type']).to include 'application/json' }
        it { expect(response.body).to include resource.rating.to_s }
      end
    end

    context 'when the user is not the author' do
      let(:resource) { create(votable) }

      it { expect { increase }.to change(resource, :rating).by(1) }

      describe 'response' do
        before { increase }

        it { expect(response.header['Content-Type']).to include 'application/json' }
        it { expect(response.body).to include resource.rating.to_s }
      end
    end
  end

  describe 'PATCH #decrease_rating' do
    subject(:decrease) { patch :decrease_rating, params: { id: resource }, format: :json }

    context 'when the user is the author' do
      let(:resource) { create(votable, author: user) }

      it { expect { decrease }.not_to change(resource, :rating) }

      describe 'response' do
        before { decrease }

        it { expect(response.header['Content-Type']).to include 'application/json' }
        it { expect(response.body).to include resource.rating.to_s }
      end
    end

    context 'when the user is not the author' do
      let(:resource) { create(votable) }

      it { expect { decrease }.to change(resource, :rating).by(-1) }

      describe 'response' do
        before { decrease }

        it { expect(response.header['Content-Type']).to include 'application/json' }
        it { expect(response.body).to include resource.rating.to_s }
      end
    end
  end
end
