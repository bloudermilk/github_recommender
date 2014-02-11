require "bundler"
Bundler.require(:default)

require File.expand_path("../lib/github_recommender", __FILE__)

GithubRecommender.boot!

GithubRecommender::API.set(:recommender, GithubRecommender::Recommender.new)

run GithubRecommender::API
