module GithubDiscover
  class User
    include Neo4j::NodeMixin

    rule :all

    property :login, type: String, index: :exact, unique: true
    property :name, type: String

    has_n(:starred).to(Repo).relationship(Star)
  end
end
