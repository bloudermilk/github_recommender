module GithubDiscover
  class Repo
    include Neo4j::NodeMixin

    property :id, type: Fixnum, index: :exact, unique: true
    property :owner, type: String
    property :name, type: String
    property :url, type: String
    property :description, type: String
    property :homepage, type: String
    property :language, type: String

    has_n(:starred_by).from(User, :starred)
  end
end
