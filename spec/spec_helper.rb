require "bundler/setup"
require "teamstuff"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define :be_a_ts_user_profile do
  match do |actual|
    expect(actual).to include("id", "email", "registered", "verified", "nickname", "name", "created_at")
  end
end
