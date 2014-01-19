module GithubDiscover
  class EventMapper
    attr_reader :event

    def initialize(event)
      @event = event
    end

    def map!
      if event["type"] == "WatchEvent"
        user = User.get_or_create(user_properties)
        repo = Repo.get_or_create(repo_properties)

        Neo4j::Transaction.run do
          repo.starred_by << user
        end
      else
        false
      end
    end

    private

    def repo_properties
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

    def user_properties
      user = event["actor_attributes"]

      {
        login: user["login"],
        name: user["name"],
      }
    end
  end
end
