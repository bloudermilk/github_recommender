module GithubDiscover
  class Star
    include Neo4j::RelationshipMixin

    property :created_at, type: Time
  end
end
