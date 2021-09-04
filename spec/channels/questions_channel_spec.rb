require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  subject { subscription }

  before { subscribe }

  it { is_expected.to be_confirmed }
  it { is_expected.to have_stream_from 'questions' }
end
