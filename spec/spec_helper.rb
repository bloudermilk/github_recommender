require "bundler/setup"
Bundler.require(:default, :test)

require File.expand_path("../../lib/github_discover", __FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = "random"
end