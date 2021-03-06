describe PullRequestAdjuster do
  subject do
    described_class.new(client,
                        message_adjuster: message_adjuster,
                        job_store:        job_store
                       )
  end

  let(:message_adjuster) { double }
  let(:pull_requests)    {}
  let(:job_store)        { {} }
  let(:commits)          { double }

  let(:client) do
    double(pull_requests: pull_requests, update_pull_request: nil)
  end

  before do
    allow(client).to receive(:commits).with(pull_request).and_return(commits)

    allow(message_adjuster).to receive(:call)
      .with(StatusMessage.new(pull_request, job, commits)).and_return(
        title:       'adjusted title',
        description: 'adjusted description'
      )

    allow(message_adjuster).to receive(:description_without_status)
      .and_return(nil)
  end

  describe '#update_status' do
    let(:job) do
      JenkinsJobExample.build(
        'build' => { 'scm' => { 'branch' => 'origin/my-branch' } }
      )
    end

    context 'when a pull request exists for the branch' do
      let(:pull_request) do
        double(
          id:          42,
          identifier:  'mybranch',
          description: 'this is my pull request',
          reviewers:   ['reviewer']
        )
      end

      let(:pull_requests) do
        [
          double(id: 1, identifier: 911),
          pull_request,
          double(id: 3, identifier: 666)
        ]
      end

      it 'does not overwrite existing reviewers' do
        subject.update_status job

        expect(client).to have_received(:update_pull_request)
          .with(42, hash_including(reviewers: ['reviewer']))
      end

      it 'updates the pull request description with the status' do
        subject.update_status job

        expect(client).to have_received(:update_pull_request)
          .with(42, hash_including(description: 'adjusted description'))
      end
    end

    context 'when a pull request does not exist for the branch' do
      let(:pull_requests) do
        [
          double(id: 1, identifier: 12),
          double(id: 3, identifier: 234)
        ]
      end

      let(:pull_request) {}

      it 'does not update any pull request' do
        subject.update_status job

        expect(client).to_not have_received(:update_pull_request)
      end
    end
  end

  describe '#update_status_from_pull_request' do
    let(:pull_request) do
      double(id: 42, identifier: 'my-branch', description: nil, reviewers: [])
    end
    let(:job_store) { { 'my-branch' => job } }
    let(:job) { double }

    it 'updates the status of the pull request' do
      subject.update_status_from_pull_request pull_request

      expect(client).to have_received(:update_pull_request)
        .with(42, hash_including(close_source_branch: true))
    end
  end

  describe '#update_status_from_pull_request_id'
  describe '#update_statuses_for_all_pull_requests'
  describe '#set_automerge_for_pull_request'
end
