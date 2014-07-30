class PullRequestInteractor
  def initialize(bitbucket:)
    @bitbucket = bitbucket
  end

  def call(params)
    pull_request_params = params['pullrequest_created'] || return
    pull_request = BitbucketClient::PullRequest.new(pull_request_params)
    @bitbucket.update_status_from_pull_request pull_request
  end

  def refresh(id)
    @bitbucket.update_status_from_pull_request_id id
  end
end