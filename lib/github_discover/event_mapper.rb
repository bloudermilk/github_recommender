module GithubDiscover
  class EventMapper
    include Celluloid
    include Celluloid::Logger

    def map(event)
      if event["type"] == "WatchEvent"
        user = User.get_or_create(user_properties(event))
        repo = Repo.get_or_create(repo_properties(event))

        Neo4j::Transaction.run do
          repo.starred_by << user
        end
      end
    end

    private

    def repo_properties(event)
      repo = event["repository"]

      {
        id: repo["id"],
        owner: repo["owner"],
        name: repo["name"],
        url: repo["url"],
        description: repo["description"],
        homepage: repo["homepage"],
        language: repo["language"],
      }
    end

    def user_properties(event)
      user = event["actor_attributes"]

      {
        login: user["login"],
        name: user["name"],
      }
    end
  end
end
