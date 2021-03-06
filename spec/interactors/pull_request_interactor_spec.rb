describe PullRequestInteractor do
  subject { described_class.new(bitbucket: bitbucket) }
  let(:bitbucket) { double }

  describe '#call' do
    let(:params)    { { action => { 'id' => 42 } } }

    describe 'a pull request created' do
      let(:action) { 'pullrequest_created' }

      before do
        allow(bitbucket).to receive(:update_status_from_pull_request)
      end

      it 'add the status to the pull request' do
        subject.call(params)
        expect(bitbucket).to have_received(:update_status_from_pull_request)
          .with(PullRequest.new('id' => 42))
      end
    end

    describe 'a pull request edited' do
      let(:action) { 'pullrequest_edited' }

      it 'does nothing and does it without exploding' do
        subject.call(params)
      end
    end
  end

  describe '#automerge' do
    before do
      allow(bitbucket).to receive(:set_automerge_for_pull_request)
    end

    describe 'turning on' do
      it 'sets automerge to true' do
        subject.automerge(42, 'on')
        expect(bitbucket).to have_received(:set_automerge_for_pull_request)
          .with(42, true)
      end
    end

    describe 'turning off' do
      it 'sets automerge to false' do
        subject.automerge(42, 'off')
        expect(bitbucket).to have_received(:set_automerge_for_pull_request)
          .with(42, false)
      end
    end
  end
end
