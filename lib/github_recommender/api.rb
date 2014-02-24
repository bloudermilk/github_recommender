require "sinatra/base"
require "sinatra/json"
require "sinatra/respond_with"

module GithubRecommender
  class API < Sinatra::Base
    helpers Sinatra::JSON
    register Sinatra::RespondWith

    enable :inline_templates

    # Automatically return connections to the pool
    use ActiveRecord::ConnectionAdapters::ConnectionManagement

    # Don't blow up when we can't find something
    error ActiveRecord::RecordNotFound do
      halt(404, message: "Page not found")
    end

    # Get Recommendations for the given User
    get "/users/:login/recommendations" do |login|
      respond_with :index do |format|
        format.html { erb :index }

        format.json do
          json settings.recommender.recommend(User.find_by!(login: login))
        end
      end
    end
  end
end

__END__

@@ index
<!DOCTYPE html>
<html>
  <head>
    <title>GitHub Recommender</title>
  </head>
  <body>
    Loading...
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
    <script>
      $(function () {
        $.getJSON(document.URL, function (data) {
          $("body").html("<pre>" + JSON.stringify(data, null, 2) + "</pre>");
        });
      });
    </script>
  </body>
</html>
