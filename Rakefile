require "bundler"
Bundler.require(:default, :development) # TODO: Remove development!!!

require File.expand_path("../lib/github_recommender", __FILE__)

namespace :db do
  desc "Migrate the database"
  task :migrate do
    GithubRecommender.boot!

    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end
