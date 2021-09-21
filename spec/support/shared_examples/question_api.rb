shared_examples 'question api' do
  let(:answer_json) { question_json['answers'].first }
  let(:comment_json) { question_json['comments'].first }
  let(:link_json) { question_json['links'].first }
  let(:file) { question.files.first }
  let(:file_json) { question_json['files'].first }

  it 'returns all public fields for question' do
    %w[id title body created_at updated_at].each do |attr|
      expect(question_json[attr]).to eq question.send(attr).as_json
    end
  end

  it 'returns list of answers' do
    expect(question_json['answers'].size).to eq 2
  end

  it 'returns all public fields for answer' do
    %w[id body best question_id author_id created_at updated_at].each do |attr|
      expect(answer_json[attr]).to eq answer.send(attr).as_json
    end
  end

  it 'returns list of comments' do
    expect(question_json['comments'].size).to eq 2
  end

  it 'returns all public fields for comment' do
    %w[id body commentable_id author_id created_at updated_at].each do |attr|
      expect(comment_json[attr]).to eq comment.send(attr).as_json
    end
  end

  it 'returns list of links' do
    expect(question_json['links'].size).to eq 2
  end

  it 'returns all public fields for links' do
    %w[name url].each do |attr|
      expect(link_json[attr]).to eq link.send(attr).as_json
    end
  end

  it 'returns list of files' do
    expect(question_json['files'].size).to eq 2
  end

  it 'returns all public fields for files' do
    expect(file_json['url']).to include 'http://www.example.com/rails/active_storage/disk/'
  end

  include_examples 'user fields' do
    let(:user) { question.author }
    let(:user_json) { question_json['author'] }
  end
end
