shared_examples_for 'Votable' do |votable|
  describe 'PATCH #change_rating' do
    subject(:change_rating) { patch :change_rating, params: { id: resource, point: 1 }, format: :json }

    context 'with valid attributes' do
      let(:resource) { create(votable) }

      it { expect { change_rating }.to change(resource, :rating).by(1) }

      describe 'response' do
        before { change_rating }

        it { expect(response.header['Content-Type']).to include 'application/json' }
        it { expect(response.body).to include resource.rating.to_s }
      end
    end

    context 'with invalid attributes' do
      let(:resource) { create(votable, author: user) }

      it { expect { change_rating }.not_to change(resource, :rating) }

      describe 'response' do
        before { change_rating }

        it { expect(response.header['Content-Type']).to include 'application/json' }
        it { expect(response.body).to include 'You are not authorized to access this page' }
      end
    end
  end

  describe 'DELETE #cancel' do
    subject(:cancel) { delete :cancel, params: { id: resource }, format: :json }

    let(:resource) { create(votable) }
    let!(:vote) { create(:vote, :for_question, votable: resource, user: user) }

    it { expect { cancel }.to change(resource.votes, :count).by(-1) }

    describe 'response' do
      before { cancel }

      it { expect(response.header['Content-Type']).to include 'application/json' }
      it { expect(response.body).to include resource.rating.to_s }
    end
  end
end
