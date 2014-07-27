module JobFactory
  def job_params(
    job_name: "the-job-name",
    url: "http://example.com/the-job",
    status: "ABOTRED",
    phase: "COMPLETED"
  )
    {
      "name"  => job_name,
      "url"   => "job/test-job-for-webhooks/",
      "build" => {
        "full_url" => url,
        "number"   => 3,
        "phase"    => phase,
        "status"   => status,
        "url"      => "job/test-job-for-webhooks/3/",
        "scm"      => {
          "url"    => "git@bitbucket.org:mountdiablo/ce_bacchus.git",
          "branch" => "origin/master",
          "commit" => "9a6e22c90bb0c90781dcf6f4ff94b52f97d80883"
        },
        "artifacts"  => {}
      }
    }
  end
end

RSpec.configure do |config|
  config.include JobFactory
end