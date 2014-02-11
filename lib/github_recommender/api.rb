require "sinatra/base"
require "sinatra/json"

module GithubRecommender
  class API < Sinatra::Base
    # Easily render JSON
    helpers Sinatra::JSON

    # Automatically return connections to the pool
    use ActiveRecord::ConnectionAdapters::ConnectionManagement

    # Don't blow up when we can't find something
    error ActiveRecord::RecordNotFound do
      halt(404, message: "Page not found")
    end

    # Get Recommendations for the given User
    get "/users/:login/recommendations" do |login|
      json settings.recommender.recommend(
        User.find_by!(login: login)
      )
    end
  end
end
