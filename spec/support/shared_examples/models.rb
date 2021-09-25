shared_examples 'shared associations' do
  it { is_expected.to belong_to(:author).class_name('User') }
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:links).allow_destroy(true) }
  it { is_expected.to validate_presence_of :body }
end

shared_examples 'shared methods' do |votable, resource_with_votes|
  describe '#files' do
    subject { described_class.new.files }

    it { is_expected.to be_an_instance_of(ActiveStorage::Attached::Many) }
  end

  describe '#rating' do
    subject { resource.rating }

    context 'with votes' do
      let(:resource) { create(resource_with_votes) }

      it { is_expected.to be resource.votes.sum(:point) }
    end

    context 'without votes' do
      let(:resource) { create(votable) }

      it { is_expected.to be_zero }
    end
  end
end
