require "bundler"
Bundler.require(:default)

require File.expand_path("../lib/github_discover", __FILE__)

GithubDiscover.connect_db!

GithubDiscover::API.set(:recommender, GithubDiscover::Recommender.new)

run GithubDiscover::API
