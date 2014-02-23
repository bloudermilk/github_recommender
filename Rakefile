require "bundler"
Bundler.require(:default)

require File.expand_path("../lib/github_recommender", __FILE__)

namespace :db do
  desc "Migrate the database"
  task :migrate do
    GithubRecommender.boot!

    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  desc "Create the database"
  task :create do
    config = GithubRecommender.db_config

    ActiveRecord::Base.establish_connection(config.merge(database: nil))
    ActiveRecord::Base.connection.create_database(config[:database])
    ActiveRecord::Base.establish_connection(config)
  end
end
