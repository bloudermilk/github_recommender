$LOAD_PATH.push(File.expand_path("../../lib", __FILE__))

module GithubRecommender
  autoload :API, "github_recommender/api"
  autoload :ArchiveDownloader, "github_recommender/archive_downloader"
  autoload :ArchiveProcessor, "github_recommender/archive_processor"
  autoload :EventMapper, "github_recommender/event_mapper"
  autoload :MultiJsonParser, "github_recommender/multi_json_parser"
  autoload :Recommender, "github_recommender/recommender"
  autoload :Repo, "github_recommender/repo"
  autoload :Scraper, "github_recommender/scraper"
  autoload :User, "github_recommender/user"

  def self.boot!
    Celluloid.logger = Logger.new($stdout)
    ActiveRecord::Base.establish_connection
  end

  def self.recommender
    @recommender ||= Recommender.new
  end

  def self.db_config
    @db_config ||= ActiveRecord::ConnectionAdapters::ConnectionSpecification::Resolver.new(ENV["DATABASE_URL"], {}).spec.config
  end
end
