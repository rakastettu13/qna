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

shared_examples 'shared fields' do
  it { expect(response).to be_successful }

  it 'returns all public fields for answer' do
    %w[id body best author_id question_id created_at updated_at].each do |attr|
      expect(answer_json[attr]).to eq answer.send(attr).as_json
    end
  end

  it 'returns list of comments' do
    expect(resourse_json['comments'].size).to eq 2
  end

  it 'returns all public fields for comment' do
    %w[id body author_id commentable_id commentable_type created_at updated_at].each do |attr|
      expect(resourse_json['comments'].first[attr]).to eq resource.comments.first.send(attr).as_json
    end
  end

  it 'returns list of links' do
    expect(resourse_json['links'].size).to eq 2
  end

  it 'returns all public fields for links' do
    %w[name url linkable_id linkable_type].each do |attr|
      expect(resourse_json['links'].first[attr]).to eq resource.links.first.send(attr).as_json
    end
  end

  it 'returns list of files' do
    expect(resourse_json['files'].size).to eq 2
  end

  it 'returns url for files' do
    expect(resourse_json['files'].first['url']).to include 'http://www.example.com/rails/active_storage/disk/'
  end
end

shared_examples 'question fields' do
  it 'returns all public fields for question' do
    %w[id title body author_id created_at updated_at].each do |attr|
      expect(resourse_json[attr]).to eq question.send(attr).as_json
    end
  end

  it 'returns list of answers' do
    expect(resourse_json['answers'].size).to eq 2
  end

  include_examples 'shared fields'
end
