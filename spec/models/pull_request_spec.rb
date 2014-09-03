require 'spec_helper'

describe PullRequest, type: :model do
  subject { described_class.new(PullRequestExample.attributes(attrs)) }

  let(:attrs) do
    {
      'source' => {
        'commit' => { 'hash' => 'abcdefghijkl' },
        'branch' => { 'name' => 'my-branch/STORY-123' }
      },
      'links' => { 'html' => { 'href' => 'http://pullrequest.com' } }
    }
  end

  describe '#branch' do
    subject { super().branch }
    it { is_expected.to eq 'my-branch/STORY-123' }
  end

  describe '#identifier' do
    subject { super().identifier }
    it { is_expected.to eq 'mybranchSTORY123' }
  end

  describe '#sha' do
    subject { super().sha }
    it { is_expected.to eq 'abcdefg' }
  end

  describe '#url' do
    subject { super().url }
    it { is_expected.to eq 'http://pullrequest.com' }
  end
end
