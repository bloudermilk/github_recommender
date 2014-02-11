require "sinatra/base"
require "sinatra/json"

module GithubDiscover
  class API < Sinatra::Base
    # Easily render JSON
    helpers Sinatra::JSON

    set :show_exceptions, false

    # Automatically return connections to the pool
    use ActiveRecord::ConnectionAdapters::ConnectionManagement

    error ActiveRecord::RecordNotFound do
      404
    end

    # Get Recommendations for the given User
    get "/users/:login/recommendations" do |login|
      json settings.recommender.recommend(
        User.find_by!(login: login)
      )
    end
  end
end
