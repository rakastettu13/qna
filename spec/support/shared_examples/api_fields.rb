shared_examples 'user fields' do
  it 'returns all public fields for user' do
    %w[id email admin achievements created_at updated_at].each do |attr|
      expect(user_json[attr]).to eq user.send(attr).as_json
    end
  end

  it 'does not return private fields for user' do
    %w[password encrypted_password].each do |attr|
      expect(user_json).not_to have_key(attr)
    end
  end
end

shared_examples 'answer fields' do
  it 'returns all public fields for answer' do
    %w[id body best author_id question_id created_at updated_at].each do |attr|
      expect(answer_json[attr]).to eq answer.send(attr).as_json
    end
  end
end

shared_examples 'answers fields' do
  describe 'answers' do
    it 'returns list of answers' do
      expect(answers_json.size).to eq 2
    end

    include_examples 'answer fields'
  end
end

shared_examples 'question fields' do
  it 'returns all public fields for question' do
    %w[id title body author_id created_at updated_at].each do |attr|
      expect(resource_json[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples 'questions fields' do
  describe 'questions' do
    it 'returns list of questions' do
      expect(json['questions'].size).to eq 2
    end

    include_examples 'question fields'
  end
end

shared_examples 'shared fields' do
  describe 'comments' do
    it 'returns list of comments' do
      expect(resource_json['comments'].size).to eq 2
    end

    it 'returns all public fields for comment' do
      %w[id body author_id commentable_id commentable_type created_at updated_at].each do |attr|
        expect(resource_json['comments'].first[attr]).to eq resource.comments.first.send(attr).as_json
      end
    end
  end

  describe 'links' do
    it 'returns list of links' do
      expect(resource_json['links'].size).to eq 2
    end

    it 'returns all public fields for links' do
      %w[name url linkable_id linkable_type].each do |attr|
        expect(resource_json['links'].first[attr]).to eq resource.links.first.send(attr).as_json
      end
    end
  end

  describe 'files' do
    it 'returns list of files' do
      expect(resource_json['files'].size).to eq 2
    end

    it 'returns url for files' do
      expect(resource_json['files'].first['url']).to include 'http://www.example.com/rails/active_storage/disk/'
    end
  end
end
