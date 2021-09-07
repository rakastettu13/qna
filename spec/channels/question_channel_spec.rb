require 'rails_helper'

RSpec.describe QuestionChannel, type: :channel do
  subject { subscription }

  let(:question) { create(:question) }

  before { subscribe(id: question.id) }

  it { is_expected.to be_confirmed }
  it { is_expected.to have_stream_from "questions/#{question.id}" }
end
